//
//  ChatViewController.m
//  Parse Chat
//
//  Created by Gui David on 6/27/22.
//

#import "ChatViewController.h"
#import "ChatCell.h"
@import Parse;

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view
    [self fetchMessages];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fetchMessages) userInfo:nil repeats:true];
}


-(void)fetchMessages {
    // Add code to be run periodically
     PFQuery *query = [PFQuery queryWithClassName:@"Message_FBU2021"];
     [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];

     query.limit = 20;

     // fetch data asynchronously
     [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
         if (posts != nil) {
             // do something with the array of object returned by the call
             self.messages = posts;
             NSLog(@"%@", self.messages);
             [self.tableView reloadData];
         } else {
             NSLog(@"%@", error.localizedDescription);
         }
     }];
}


- (IBAction)startEditing:(id)sender {
    self.messageField.text = @"";
}


- (IBAction)sendMessage:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_FBU2021"];
    
    chatMessage[@"text"] = self.messageField.text;
    
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                NSLog(@"The message was saved!");
            } else {
                NSLog(@"Problem saving message: %@", error.localizedDescription);
            }
        }];
    
    // Clears message field
    self.messageField.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    
    //Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    cell.messageField.text = self.messages[indexPath.row][@"text"];
    PFUser *user = self.messages[indexPath.row][@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.username.text = user.username;
    } else {
        // No user found, set default username
        cell.username.text = @"🤖";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

@end
