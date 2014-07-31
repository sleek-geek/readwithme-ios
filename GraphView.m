//
//  GraphView.m
//  MyGraph
//
//  Created by Francisco Salazar on 11/19/12.
//  Copyright (c) 2012 Francisco Salazar. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView
@synthesize aLabel;
@synthesize testArray, fluencyArray, levelsArray, datesArray, boolNum;



 
 
 
BOOL isAccuracyGraph;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
                
    }
    return self;
}

-(void)viewDidLoad{
    
    NSNumber *cwmpNum =[NSNumber numberWithFloat:0.1];
    NSNumber *cwpmNum2 = [NSNumber numberWithFloat:0.05];
    NSNumber *cwpmNum3 = [NSNumber numberWithFloat:0.85];
    
    cwpmDataArr=[[NSMutableArray alloc]initWithObjects:cwmpNum, cwpmNum2,cwpmNum3, nil];
    
   // NSLog(@"viewDidLoad");
    
       [self viewDidLoad];
}

//float data[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77};
float data[] = {0.7, 0.4, 0.9, 1.0, 0.2, 0.85, 0.11, 0.75, 0.53, 0.44, 0.88, 0.77, 0.99, 0.55};

- (void)drawBar:(CGRect)rect context:(CGContextRef)ctx
{
    /*
    CGContextBeginPath(ctx);
    CGContextSetGrayFillColor(ctx, 0.2, 0.7);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    */
    CGFloat components[12] = {0.0, 0.0, 0.4, 1.0,  // Start color
        0.4727, 1.0, 1.0, 1.0, // Second color
        0.0, 0.0, 0.4118, 1.0}; // End color
    CGFloat locations[3] = {0.0, 0.33, 1.0};
    size_t num_locations = 3;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    CGPoint startPoint = rect.origin;
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    // Create and apply the clipping path
    CGContextBeginPath(ctx);
    CGContextSetGrayFillColor(ctx, 0.2, 0.7);
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(ctx);
     
    
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    // Draw the gradient
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    // Release the resources
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
    
    
}
- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    
    
      if (isAccuracyGraph) {
    
    
    CGContextSetLineWidth(ctx, 4.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:0.0 green:0.5 blue:.8 alpha:1.0] CGColor]);
    
    int maxGraphHeight = kGraphHeight - kOffsetY;
    
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.0 green:0.5 blue:0.8 alpha:0.7] CGColor]);
    
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight *[[differenceArray objectAtIndex:0] floatValue]  );
    
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight);
       
    
    float stabalizerFloat=0.0;
    
    for  (int i=0; i<differenceArray.count; i++) {
               
        float z = ([[differenceArray objectAtIndex:i] floatValue]  ) ;
        
        
        CGContextAddLineToPoint(ctx, kOffsetX + i * stepXbaby, kGraphHeight - maxGraphHeight * z);//change y
        stabalizerFloat=kOffsetX + i * stepXbaby; //on the last pass it will set the actual x position...
        
    }
    
          CGContextAddLineToPoint(ctx, stabalizerFloat   , kGraphHeight);
          CGContextClosePath(ctx);
          CGContextDrawPath(ctx, kCGPathFill);
          
          CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.0 green:0.5 blue:0.8 alpha:1.0] CGColor]);
    
      
    for (int i = 0; i < differenceArray.count; i++)
    {
        float x = kOffsetX + i * stepXbaby;
        
       float w= kGraphHeight - maxGraphHeight *[[differenceArray objectAtIndex:i] floatValue];
        
             
       // CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 3 * kCircleRadius, 3 * kCircleRadius);
        CGRect rect = CGRectMake(x - kCircleRadius, w - kCircleRadius, 3 * kCircleRadius, 3 * kCircleRadius);
        CGContextAddEllipseInRect(ctx, rect);
        
        touchAreas [i]=rect;
        
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);


    touchAreasINT=differenceArray.count;
    
      } else //if not ACCURACY, then it is FLUENCY Graph
      
      {
          
          
          
          CGContextSetLineWidth(ctx, 4.0);
          CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:0.0 green:0.5 blue:.8 alpha:1.0] CGColor]);
          
          int maxGraphHeight = kGraphHeight - kOffsetY;
          
          CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.0 green:0.5 blue:0.8 alpha:0.7] CGColor]);
          
          CGContextBeginPath(ctx);
          
         
          
          float stabFloat = (   kGraphHeight - maxGraphHeight *[[differenceArray objectAtIndex:0] floatValue]);
          
          float subtractCoeff=0.2f;
          
          
          stabFloat=stabFloat-(stabFloat*subtractCoeff);
          
                 
          CGContextMoveToPoint(ctx, kOffsetX, stabFloat  );
          
          CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight);
          
          
          float stabalizerFloat=0.0;
           
          
          for  (int i=0; i<differenceArray.count; i++) {
              
              float z = ([[differenceArray objectAtIndex:i] floatValue]  ) ;
              
              stabFloat = (   kGraphHeight - maxGraphHeight *z);
              
            //  NSLog(@"stabFloat= %.2f", stabFloat);
              
              //let's make the conversion X.2 of the stab float
              
             stabFloat=stabFloat-(stabFloat*subtractCoeff);
               
        //      NSLog(@"stabFloat After Conversion: %.2f", stabFloat);
              
              
              CGContextAddLineToPoint(ctx, kOffsetX + i * stepXbaby, stabFloat);//change y
              
              
              stabalizerFloat=kOffsetX + i * stepXbaby; //on the last pass it will set the actual x position...
              
          }
          
          CGContextAddLineToPoint(ctx, stabalizerFloat   , kGraphHeight);
          CGContextClosePath(ctx);
          CGContextDrawPath(ctx, kCGPathFill);
          
          CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.0 green:0.5 blue:0.8 alpha:1.0] CGColor]);
          
         // NSLog(@"cwpmData arr has: %i", cwpmDataArr.count);
          
          for (int i = 0; i < differenceArray.count; i++)
          {
              float x = kOffsetX + i * stepXbaby;
              
              float w= kGraphHeight - maxGraphHeight *[[differenceArray objectAtIndex:i] floatValue];
            //  stabFloat=stabFloat-(stabFloat*subtractCoeff);
               
              w=w-(w*subtractCoeff);
              
               
              // CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 3 * kCircleRadius, 3 * kCircleRadius);
              CGRect rect = CGRectMake(x - kCircleRadius, w - kCircleRadius, 3 * kCircleRadius, 3 * kCircleRadius);
              CGContextAddEllipseInRect(ctx, rect);
              
              touchAreas [i]=rect;
              
          }
          
          CGContextDrawPath(ctx, kCGPathFillStroke);
          
          
          touchAreasINT=differenceArray.count;
          
          
          
          
      }
}

 
//detecting touches in circles...


CGRect touchAreas[kNumberOfBars];

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
   // NSLog(@"Touch x:%f, y:%f", point.x, point.y);
    
    for (int i = 0; i < differenceArray.count; i++)
    {
        if (CGRectContainsPoint(touchAreas[i], point))
        {
             
            
            aLabel=[[LabelForGraphVC alloc]initWithNibName:@"LabelForGraphVC" bundle:nil];
            
            
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterShortStyle];
            [formatter setTimeStyle:NSDateFormatterNoStyle];
            
            NSString *dateToDisplay=[formatter stringFromDate:[datesArray objectAtIndex:i] ];
         //   NSLog(@"Date to display %@", dateToDisplay);
            
                        
            popover = [[UIPopoverController alloc] initWithContentViewController:aLabel];
            aLabel.dateLBL.text=dateToDisplay;
            aLabel.cwpmLBL.text=[NSString stringWithFormat:@"%.0f cwpm", [[fluencyArray objectAtIndex:i]floatValue]];
            aLabel.accuracyLBL.text=[NSString stringWithFormat:@"%.0f%%",[[testArray objectAtIndex:i] floatValue]];
            
            if ([[levelsArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
                  aLabel.levelLBL.text =[levelsArray objectAtIndex:i];
            } else if ([[levelsArray objectAtIndex:i] isKindOfClass:[NSNumber class]]){
                
                
                int value=[[levelsArray objectAtIndex:i] intValue];
                
                NSString *stringVal=[NSString stringWithFormat:@"%i", value];
                
                aLabel.levelLBL.text=stringVal;
                
                
            }
           
            
            [popover presentPopoverFromRect:touchAreas[i] inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
                       
            
            
            

            
            
        }
    }
    
}


-(void) setDataForGraph {
    
    
    isAccuracyGraph =[boolNum boolValue];
    
    if (isAccuracyGraph) {
         
        
    
    if (testArray.count!=0 ) {
         
     
    stepXbaby= self.frame.size.width/([testArray count]);
    
    stepsArray =[[NSMutableArray alloc] init ];
    
    NSMutableArray* sortedNumbers = [NSMutableArray arrayWithArray:testArray];
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [sortedNumbers sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];

     
                                
    
  //  NSLog(@"testarray: %@", highestToLowest );
    
    float lowestNum =[[sortedNumbers lastObject] floatValue];
    
     
    
    float highestNum= [[sortedNumbers objectAtIndex:0] floatValue];
    
    //find difference
    float difference= highestNum-lowestNum;
        
    
  //  NSLog(@"difference is of %.0f and %.0f is : %.0f", highestNum, lowestNum,  difference);

    //divide maxgraphheight
    
    int maxGraphHeight = kGraphHeight - kOffsetY;
   
    
    if (difference!=0){
     eachStep= maxGraphHeight/difference ;  //adding 2 will make it more steps
      //  NSLog(@"eachsteps will be : %.0f pixels", eachStep);
        
    } //else? what if there is no difference? create one
    else {
        difference=20.0f;
        eachStep= maxGraphHeight/difference;
         
    }
    
    //find eachDifference
        
        
             
        
   differenceArray=[[NSMutableArray alloc] initWithCapacity:testArray.count]; 
    
  //  NSLog(@"testarray %@ and count %i", testArray, testArray.count );
    
    for (int i=0; i<testArray.count; i++) {
        
        
       // NSLog(@" Test array for i: %i", [[testArray objectAtIndex:i] intValue]);
        
         float differenceFloat =   highestNum - [[testArray objectAtIndex:i] floatValue];
        
        float conversion = differenceFloat/(difference+2);
        
        float oneMinusConversion = 1.0f -conversion;
        
        
        NSNumber *newFloatNUM =[NSNumber numberWithFloat:oneMinusConversion];
        
        
        
        [differenceArray addObject:newFloatNUM];
        
        
             }
    
    
    //now set the differenceFloat after they have been added to the difference +2 for drawing purposes
    
    
  //  NSLog(@"Difference Array has: %@", differenceArray);
    
    /*
     
     Find the difference of highest score and lowest score. so 100   87, difference is 13. the graph height will be 13 steps high, so welll divide the maxgraphheight by 13 to give us 13 steps (howmanySteps). 
     Then the accuracy percent will be so a score of 90 is tree steps up from the bottom 90 :100 = x/13
     maxgraphHeight/howmanySteps = eachStep= 22.3 pxls
     maxGraphHeight = 
     
     how to then translate 95% is 100 -95, so its 5 steps away from the top, another score of 89 is 11 steps from top. 
     find each difference....
     
     howmanysteps:maxgraphheight = 1.0/ difference
     13/maxGraphHeight = x/ 1
     x=13/maxgraphHeight
     
     
      13/maxgraphheight will be used for graph, but to add another buffer we need 2 more values, on on top and on bottom...
     howmany should be difference +2, or 15 steps but when draing still use the 13/maxGrapHeigh
     
     
     
     
     */
    
    
    

    
    } else {
        
        
        
      //  NSLog(@"test array is empty");
        
    }

        
    } else{
        
        
        //  NSLog(@"This is an FLUENNCY Graph");
        
        if (fluencyArray.count!=0 ) {
            
            
            // stepXbaby= kDefaultGraphWidth/([cwpmDataArr count]);
           // NSLog(@"OffsetXBaby: %i", stepXbaby);
            
            
            
            
            // testArray=[[NSMutableArray alloc]initWithObjects: num1, num2,num3,  nil];
            
            // stepXbaby= kDefaultGraphWidth/([testArray count]);
            stepXbaby= self.frame.size.width/([fluencyArray count]);
            
            stepsArray =[[NSMutableArray alloc] init ];
            
            NSMutableArray* sortedNumbers = [NSMutableArray arrayWithArray:fluencyArray];
            
            NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
            [sortedNumbers sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
            
            
            
            
          //  NSLog(@"testarray: %@", highestToLowest );
            
            float lowestNum =[[sortedNumbers lastObject] floatValue];
            
            
            
            float highestNum= [[sortedNumbers objectAtIndex:0] floatValue];
            
            //find difference
            float difference= highestNum-lowestNum;
            
           //  NSLog(@"Fluency Difference is : %.1f", difference );
            //  NSLog(@"difference is of %.0f and %.0f is : %.0f", highestNum, lowestNum,  difference);
            
            //divide maxgraphheight
            
            int maxGraphHeight = kGraphHeight - kOffsetY;
            
            
            if (difference!=0){
                eachStep= maxGraphHeight/difference ;  //adding 2 will make it more steps
                //  NSLog(@"eachsteps will be : %.0f pixels", eachStep);
                
            } //else? what if there is no difference? create one
            else {
                difference=20.0f;
                eachStep= maxGraphHeight/difference;
                
            }
            
            //find eachDifference
            
            
            
            
            differenceArray=[[NSMutableArray alloc] initWithCapacity:fluencyArray.count]; //need to make this nil when switching views
            
            //  NSLog(@"testarray %@ and count %i", testArray, testArray.count );
            
            for (int i=0; i<fluencyArray.count; i++) {
                
                
                // NSLog(@" Test array for i: %i", [[testArray objectAtIndex:i] intValue]);
                
                float differenceFloat =   highestNum - [[fluencyArray objectAtIndex:i] floatValue];
                
                float conversion = differenceFloat/(difference+2);
                
                float oneMinusConversion = 1.0f -conversion;
                
                
                NSNumber *newFloatNUM =[NSNumber numberWithFloat:oneMinusConversion];
                
                
                
                [differenceArray addObject:newFloatNUM];
                
                
            }
            
            
            //now set the differenceFloat after they have been added to the difference +2 for drawing purposes
            
            
       //     NSLog(@"Difference Array has: %@", differenceArray);
            
            /*
             
             Find the difference of highest score and lowest score. so 100   87, difference is 13. the graph height will be 13 steps high, so welll divide the maxgraphheight by 13 to give us 13 steps (howmanySteps).
             Then the accuracy percent will be so a score of 90 is tree steps up from the bottom 90 :100 = x/13
             maxgraphHeight/howmanySteps = eachStep= 22.3 pxls
             maxGraphHeight = 
             
             how to then translate 95% is 100 -95, so its 5 steps away from the top, another score of 89 is 11 steps from top. 
             find each difference....
             
             howmanysteps:maxgraphheight = 1.0/ difference
             13/maxGraphHeight = x/ 1
             x=13/maxgraphHeight
             
             
             13/maxgraphheight will be used for graph, but to add another buffer we need 2 more values, on on top and on bottom...
             howmany should be difference +2, or 15 steps but when draing still use the 13/maxGrapHeigh
             
             
             
             
             */
            
            
            
            
            
        } 
        
        
    }//end of ifAccuracyGraph
        
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  //  NSLog(@"draw rect");
    [self setDataForGraph];
    
    // Drawing code
    
    
    if (isAccuracyGraph) {
         
      //  NSLog(@"Accuracy DRAW RECT");
    
    if (testArray.count!=0) {
         
   
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.6); //line width
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]); //setting the color
    CGFloat dash[] ={2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    int howMany =(kDefaultGraphWidth -kOffsetX)/stepXbaby;
    
    //here the lines go
    
    for (int i=0; i<=howMany; i++) {
        
        CGContextMoveToPoint(context,  kOffsetX +i*stepXbaby  , kGraphTop);
        
        CGContextAddLineToPoint(context, kOffsetX + i* stepXbaby, kGraphBottom);
    }
     
        
    
      float maxGraphHeight = kGraphHeight - kOffsetY;
    //int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    float howManyHorizontal = maxGraphHeight / eachStep;
        
        
    
  //  NSLog(@" Max Graph Height =%.1f / each step(%f) = How many horizontal lines: %.1f", maxGraphHeight,eachStep,  howManyHorizontal);
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom -kOffsetY - i * eachStep);//take out kStepY
        CGContextAddLineToPoint(context, kDefaultGraphWidth-stepXbaby +20, kGraphBottom -kOffsetY - i * eachStep);//took out kStepY
        
    }
    
    CGContextStrokePath(context);
    
    CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
 /*
    
    
    float maxBarHeight = kGraphHeight - kBarTop - kOffsetY;
    
    for (int i=0; i<sizeof(data); i++) {
        
        float barX = kOffsetX + kStepX + i*kStepX - kBarWidth/2;
        
        float barY = kBarTop + maxBarHeight - maxBarHeight * data[i];
        
        float barHeight = maxBarHeight *data[i];
        
        CGRect barRect = CGRectMake(barX, barY, kBarWidth, barHeight);
        
        [self drawBar:barRect context:context];
        
     
    }
  */
    
    [self drawLineGraphWithContext:context];
    
    /*
    CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, "HelveticaNeue-Light", 44, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    NSString *theText = @"Hi there!";
    CGContextShowTextAtPoint(context, 100, 100, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
    */
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    
    //for (int i = 1; i < cwpmDataArr.count; i++)
   // for (int i = 1; i < sizeof(data); i++)
   for (int i = 0; i < differenceArray.count; i++)
        
    {
        NSString *theText = [NSString stringWithFormat:@"%d", i];
        CGContextShowTextAtPoint(context, kOffsetX + i * stepXbaby, kGraphBottom - 5, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
    }
    
    //need to get number of steps...
    
   // int stepsINT =eachStep;
    
for (int i = 0; i < testArray.count; i++)

{
    NSString *theText = [NSString stringWithFormat:@"%d", i];
    CGContextShowTextAtPoint(context, kOffsetX + i * stepXbaby, kGraphBottom - 5, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
}


         }
        
        
        
    } else {
        if (fluencyArray.count!=0) {
            
         //   NSLog(@"Fluency DRAW RECT");
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 0.6); //line width
            CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]); //setting the color
            CGFloat dash[] ={2.0, 2.0};
            CGContextSetLineDash(context, 0.0, dash, 2);
            
            int howMany =(kDefaultGraphWidth -kOffsetX)/stepXbaby;
            
            //here the lines go
            
            for (int i=0; i<=howMany; i++) {
                
                CGContextMoveToPoint(context,  kOffsetX +i*stepXbaby  , kGraphTop);
                
                CGContextAddLineToPoint(context, kOffsetX + i* stepXbaby, kGraphBottom);
            }
            
           
            
            if (eachStep<20) {
                
                eachStep=eachStep*10;
                
            }
            
            float maxGraphHeight = kGraphHeight - kOffsetY;
            //int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
            float howManyHorizontal = maxGraphHeight / eachStep;
            
            
        //    NSLog(@" Max Graph Height =%.1f / each step(%f) = How many horizontal lines: %.1f", maxGraphHeight,eachStep,  howManyHorizontal);
            
            for (int i = 0; i <= howManyHorizontal; i++)
            {
                
                CGContextMoveToPoint(context, kOffsetX, kGraphBottom -kOffsetY - i * eachStep);//take out kStepY
                CGContextAddLineToPoint(context, kDefaultGraphWidth-stepXbaby +20, kGraphBottom -kOffsetY - i * eachStep);//took out kStepY
                
            }
            
            CGContextStrokePath(context);
            
            CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
            /*
             
             
             float maxBarHeight = kGraphHeight - kBarTop - kOffsetY;
             
             for (int i=0; i<sizeof(data); i++) {
             
             float barX = kOffsetX + kStepX + i*kStepX - kBarWidth/2;
             
             float barY = kBarTop + maxBarHeight - maxBarHeight * data[i];
             
             float barHeight = maxBarHeight *data[i];
             
             CGRect barRect = CGRectMake(barX, barY, kBarWidth, barHeight);
             
             [self drawBar:barRect context:context];
             
             
             }
             */
            
            [self drawLineGraphWithContext:context];
            
            /*
             CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
             CGContextSelectFont(context, "HelveticaNeue-Light", 44, kCGEncodingMacRoman);
             CGContextSetTextDrawingMode(context, kCGTextFill);
             CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
             NSString *theText = @"Hi there!";
             CGContextShowTextAtPoint(context, 100, 100, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
             */
            CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
            CGContextSelectFont(context, "Helvetica", 18, kCGEncodingMacRoman);
            CGContextSetTextDrawingMode(context, kCGTextFill);
            CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
            
            //for (int i = 1; i < cwpmDataArr.count; i++)
            // for (int i = 1; i < sizeof(data); i++)
            for (int i = 0; i < differenceArray.count; i++)
                
            {
                NSString *theText = [NSString stringWithFormat:@"%d", i];
                CGContextShowTextAtPoint(context, kOffsetX + i * stepXbaby, kGraphBottom - 5, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
            }
            
            //need to get number of steps...
            
            // int stepsINT =eachStep;
            
            for (int i = 0; i < fluencyArray.count; i++)
                
            {
                NSString *theText = [NSString stringWithFormat:@"%d", i];
                CGContextShowTextAtPoint(context, kOffsetX + i * stepXbaby, kGraphBottom - 5, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
            }
            
            
        }
        
        
        
        
        
    }
        
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
 

@end


