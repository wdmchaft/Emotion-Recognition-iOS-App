//
//  OCPasswordPromptView.h
//  TextPrompt
//
//  Created by Objective Coders LLC on 12/31/10.
//

#import <UIKit/UIKit.h>

@interface OCPasswordPromptView : UIAlertView
{
	UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

- (id)initWithPrompt:(NSString *)prompt message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle;
- (NSString *)enteredText;

@end
