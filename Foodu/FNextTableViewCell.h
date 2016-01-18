//
//  FNextTableViewCell.h
//  Foodu
//
//  Created by Abbin on 06/01/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface FNextTableViewCell : PFTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nextLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *cellActivityIndicator;

@end
