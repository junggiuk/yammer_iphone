#import "TTTableYammerItemCell.h"
#import "TTTableYammerItem.h"
#import "YammerMessage.h"
#import "MessageView.h"
#import "ColorBackground.h"

@implementation TTTableYammerItemCell

@synthesize messageView = _messageView;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
  TTTableYammerItem* item = object;
  
  CGSize size = [[item.message objectForKey:@"plain_body"] sizeWithFont:[UIFont systemFontOfSize:[MessageView previewFontSize]]
                 constrainedToSize:CGSizeMake(230, [item maxPreviewHeight])
                 lineBreakMode:UILineBreakModeTailTruncation];

  int h = size.height + 40;
  
  if (item.isDetail)
    return 60.0;
  
  return h;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
  if (self = [super initWithStyle:style reuseIdentifier:identifier]) {    
    self.messageView = [[MessageView alloc] init];
    [self.contentView addSubview:_messageView];
	}
  
	return self;
}

- (void)dealloc {  
  TT_RELEASE_SAFELY(_messageView);
	[super dealloc];
}

- (void)setObject:(id)object {
  if (_item != object) {
    [super setObject:object];
    
    TTTableYammerItem* item = object;

    _messageView.fromLine.text = [item.message objectForKey:@"from"];
    _messageView.timeLine.text = [YammerMessage timeString:item];
    _messageView.mugshot.URL   = [item.message objectForKey:@"actor_mugshot_url"];
    
    if (item.isDetail == YES) {
      [_messageView timeLineToOriginalPosition];
      [_messageView adjustFromLineIcons:item];

      _messageView.iconLike.hidden = YES;
      _messageView.messageText.hidden = YES;
      _messageView.messageText.text = @"";
      if ([[item.message objectForKey:@"likes"] intValue] > 0) {
        _messageView.iconLike.hidden = NO;
        _messageView.messageText.hidden = NO;
        int like_int_val = [[item.message objectForKey:@"likes"] intValue];
        
        if (like_int_val == 1)
          _messageView.messageText.text = [NSString stringWithFormat:@"Liked by 1 person."];
        else
          _messageView.messageText.text = [NSString stringWithFormat:@"Liked by %d people.", like_int_val];
        _messageView.messageText.frame = CGRectMake(71, 19, 200, 15);
      }
      return;
    }

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    _messageView.messageText.text = [item.message objectForKey:@"plain_body"];
    _messageView.messageText.hidden = NO;
    [_messageView adjustWidthsAndHeights:item];
    [_messageView adjustFromLineIcons:item];
        
    if ([item.message objectForKey:@"fill"]) {
      self.backgroundView = [[ColorBackground alloc] initWithColor:[item.message objectForKey:@"fill"]];     
      [_messageView setMultipleBackgrounds:[item.message objectForKey:@"fill"]];
    } else {
      self.backgroundView = [[ColorBackground alloc] initWithColor:[UIColor whiteColor]];     
      [_messageView setMultipleBackgrounds:[UIColor whiteColor]];
    }
    
  }
}


@end
