//
//  AsyncImage.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/06/24.
//

import SwiftUI
import Combine

struct AsyncImageUnderiOS15<Placeholder: View, I: View>: View {
    @StateObject private var loader: ImageLoader
    
    private let placeholder: Placeholder
    private let content: (Image) -> I
    
    init(url: URL?, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: () -> Placeholder) {
        self.placeholder = placeholder()
        self.content = content
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        imageBuilder
            .onAppear {
                loader.load()
            }
    }
    
    @ViewBuilder
    private var imageBuilder: some View {
        if let loadedImage = loader.image {
            content(Image(uiImage: loadedImage))
        } else {
            placeholder
        }
    }
}

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL?
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL?, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        
        guard let url = url else {
            return
        }
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        if let url = url {
            image.map { cache?[url] = $0 }
        }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
