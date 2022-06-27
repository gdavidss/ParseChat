//
//  ChatCell.m
//  Parse Chat
//
//  Created by Gui David on 6/27/22.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.messageField.layer.cornerRadius = 4;
    self.messageField.clipsToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
