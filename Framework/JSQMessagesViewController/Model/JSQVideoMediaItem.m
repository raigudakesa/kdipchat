//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQVideoMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"

#import "UIImage+JSQMessages.h"


@interface JSQVideoMediaItem ()

@property (strong, nonatomic) UIImageView *cachedVideoImageView;

@end


@implementation JSQVideoMediaItem

#pragma mark - Initialization

- (instancetype)initWithFileURL:(NSURL *)fileURL isReadyToPlay:(BOOL)isReadyToPlay
{
    self = [super init];
    if (self) {
        _fileURL = [fileURL copy];
        _isReadyToPlay = isReadyToPlay;
        _cachedVideoImageView = nil;
        //_thumbnailImage = nil;
    }
    return self;
}

- (void)dealloc
{
    _fileURL = nil;
    _cachedVideoImageView = nil;
    _thumbnailImage = nil;
}

#pragma mark - Setters

- (void)setFileURL:(NSURL *)fileURL
{
    _fileURL = [fileURL copy];
    _cachedVideoImageView = nil;
    //_thumbnailImage = nil;
}

- (void)setIsReadyToPlay:(BOOL)isReadyToPlay
{
    _isReadyToPlay = isReadyToPlay;
    _cachedVideoImageView = nil;
    //_thumbnailImage = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedVideoImageView = nil;
    //_thumbnailImage = nil;
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.fileURL == nil || !self.isReadyToPlay) {
        return nil;
    }
    
    if (self.cachedVideoImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        UIView *mediaContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        UIImage *playIcon = [[UIImage jsq_defaultPlayImage] jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
        
        // Play Icon
        UIImageView *imageView = [[UIImageView alloc] initWithImage:playIcon];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.frame = CGRectMake(mediaContainer.frame.size.width/2 - 25.0f, mediaContainer.frame.size.height/2 - 25.0f, 50.0f, 50.0f);
        imageView.contentMode = UIViewContentModeCenter;
        imageView.clipsToBounds = YES;
        
        // Thumbnail Image
        UIImageView *thumbView = [[UIImageView alloc] initWithImage:self.thumbnailImage];
        thumbView.backgroundColor = [UIColor blackColor];
        thumbView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        thumbView.contentMode = UIViewContentModeScaleAspectFill;
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:mediaContainer isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        //self.cachedVideoImageView = imageView;
        [mediaContainer addSubview:thumbView];
        [mediaContainer addSubview:imageView];
        
        return mediaContainer;
    }
    
    return self.cachedVideoImageView;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }
    
    JSQVideoMediaItem *videoItem = (JSQVideoMediaItem *)object;
    
    return [self.fileURL isEqual:videoItem.fileURL]
            && self.isReadyToPlay == videoItem.isReadyToPlay;
}

- (NSUInteger)hash
{
    return super.hash ^ self.fileURL.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: fileURL=%@, isReadyToPlay=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.fileURL, @(self.isReadyToPlay), @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _fileURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileURL))];
        _isReadyToPlay = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isReadyToPlay))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.fileURL forKey:NSStringFromSelector(@selector(fileURL))];
    [aCoder encodeBool:self.isReadyToPlay forKey:NSStringFromSelector(@selector(isReadyToPlay))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQVideoMediaItem *copy = [[[self class] allocWithZone:zone] initWithFileURL:self.fileURL
                                                                   isReadyToPlay:self.isReadyToPlay];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
