//
//  ClassmateViewController.m
//  Snippets
//
//  Created by Walker on 2020/12/2.
//  Copyright © 2020 Walker. All rights reserved.
//

#import "ClassmateContactViewController.h"
#import "ClassmateContact.h"

@interface ClassmateContactViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) ClassmateContact *contact;
@end

@implementation ClassmateContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.contact = [ClassmateContact new];
    self.contact.name = @"Yapeng Wang";
    self.contact.nickname = @"Walker";
    self.contact.email = @"wwalkerrr@gmail.com";
    self.contact.city = @"Xi'an Shannxi";
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateTextFields];
}

- (NSArray *)contactStringKeys;{
    return @[@"name", @"nickname", @"email", @"city"];
}

- (UITextField *)textFieldForModelKey:(NSString *)key{
    return [self valueForKey:[key stringByAppendingString:@"TextField"]];
}

// 更新UI
- (void)updateTextFields{
    for (NSString *key in [self contactStringKeys]) {
        [[self textFieldForModelKey:key] setText:[self.contact valueForKey:key]];
    }
}

// 更新Model
- (void)textFieldDidEndEditing:(UITextField *)textField{
    for (NSString *key in [self contactStringKeys]) {
        UITextField *tf = [self textFieldForModelKey:key];
        if (tf == textField) {
            NSString *value = textField.text;
            NSError *error;
            if ([key isEqualToString:@"name"])
                [self.contact validateName:&value error:&error];
            [self.contact setValue:value forKey:key];
            break;
        }
    }
    NSLog(@"contact:%@", self.contact);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignFirstResponder];
}

@end
