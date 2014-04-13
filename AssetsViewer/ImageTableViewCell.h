//
//  ImageTableViewCell.h
//  AssetsViewer
//
//  Created by 相澤 隆志 on 2014/04/12.
//  Copyright (c) 2014年 相澤 隆志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *DateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cameraModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *makerLabel;

@end
