#import "Crop.h"
#include <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>

@implementation Crop

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(crop:(NSString *)base64
                  x:(CGFloat)x
                  y:(CGFloat)y
                  width:(CGFloat)width
                  height:(CGFloat)height
                  callback:(RCTResponseSenderBlock)callback)
{
    @try
    {
        CGRect cropArea = CGRectMake(x, y, width, height);
        UIImage* imageToCrop = [self getFromBase64:base64];
        CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], cropArea);
        UIImage* croppedImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        NSString *base64CroppedImage = [UIImagePNGRepresentation(croppedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return callback(@[base64CroppedImage]);
    }
    @catch(NSException * exception)
    {
        return callback(@[@""]);
    }
}

- (UIImage*) getFromBase64:(NSString*)base64
{
    if ([base64 hasPrefix:@"data:image/"] == NO) {
        base64 = [@"data:image/png;base64," stringByAppendingString:base64];
    }
    NSURL *url = [NSURL URLWithString:base64];
    NSData *originalImageData = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:originalImageData];
}

@end
