//
//  TouchTestViewModel.swift
//  VerizonDoctor
//
//  Created by Manikaraj, Jayaprakash (Cognizant) on 26/06/25.
//

import Foundation

class TouchTestViewModel: ObservableObject {
    @Published var clearedCells: Set<Int> = []
    @Published var showCompletionPrompt = false
    @Published var showResultOverlay = false
    @Published var testCompleted = false
    @Published var testPassed = false
    @Published var testResult: TestResult? = nil

    let testCase: TestCase
    var gridSize = 0
    private var promptTimer: Timer?
    private var startTime: Date?

    init(testCase: TestCase) {
        self.testCase = testCase
    }
    
    func startTest() {
        clearedCells = []
        testCompleted = false
        testPassed = false
        showCompletionPrompt = false
        showResultOverlay = false
        startTime = Date()
        scheduleCompletionPrompt()
    }

    func clearCell(_ index: Int) {
        guard !testCompleted else { return }
        clearedCells.insert(index)

        if clearedCells.count == gridSize {
            testPassed = true
            finishTest(manualChoice: nil) // auto-pass
        }
    }

    func finishTest(manualChoice: Bool?) {
        testCompleted = true
        promptTimer?.invalidate()

        if let manual = manualChoice {
            testPassed = manual
        }
        showResultOverlay = true
        testResult = TestResult(
            result: testPassed,
            testCase: testCase,
            summary: testPassed ? DiagnosticStrings.touchPassSummary : DiagnosticStrings.touchFailSummary,
            details: testPassed ? DiagnosticStrings.touchSuccessDetails : DiagnosticStrings.touchFailureDetails,
            timestamp: Date(),
            duration: startTime.map { Date().timeIntervalSince($0) }
        )
    }
    func scheduleCompletionPrompt() {
        promptTimer?.invalidate()
        promptTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
            guard let self = self, !self.testCompleted else { return }
            self.showCompletionPrompt = true
        }
    }
    
    func indexForTouch(location: CGPoint, in screenSize: CGSize, cellSize: CGFloat, spacing: CGFloat) -> Int? {
        let columnsCount = Int((screenSize.width + spacing) / (cellSize + spacing))
        let column = Int(location.x / (cellSize + spacing))
        let row = Int(location.y / (cellSize + spacing))
        let index = row * columnsCount + column
        return index >= 0 && index < gridSize ? index : nil
    }
}

/*
#define count_axis 4
#define base_tag_x 100
#define base_tag_y 200

#define alert_ins_body      @"Tap \"Start Test\", and then place more than one finger on the screen for multi-touch identification."
#define alert_confirm_body  @"Have you placed more than one fingers on the screen?"
#define alert_test_success  @"Multi-touch detect successfully.\n\nPlease continue the Touch sensor validation by touching all gridboxes on the screen in next 15 seconds."
#define alert_title         @"Multi-touch Test"

@interface VZMultiTouchViewController (){
    UIAlertView *insAlertView;
    UIAlertView *confirmAlertView;
    UIAlertView *multitouchSuccessAlert;
    NSTimer *confirmAlertTimer;
    BOOL isMutitouchCheck;
    
}
@end

@implementation XXXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isMutitouchCheck = NO;
    [super stopTimer];
    [self initializeAlert];
    [self showInstructionAlert];
    [self initAxis];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Timer

-(void)confirmAlertStartTimer {
    confirmAlertTimer = nil;
    if (!confirmAlertTimer) {
        confirmAlertTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(showConfirmAlert) userInfo:nil repeats:YES];
    }
}

-(void)confirmAlertStopTimer {
    [confirmAlertTimer invalidate];
}



#pragma makr - UIAlertView
-(void)initializeAlert {
    insAlertView = [[UIAlertView alloc]initWithTitle:alert_title message:alert_ins_body delegate:self cancelButtonTitle:@"Start Test" otherButtonTitles:nil];
    confirmAlertView = [[UIAlertView alloc]initWithTitle:alert_title message:alert_confirm_body delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Restart Test",nil];
    multitouchSuccessAlert = [[UIAlertView alloc]initWithTitle:alert_title message:alert_test_success delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
}

-(void)showInstructionAlert {
    [insAlertView show];
}

-(void)showConfirmAlert {
    [self confirmAlertStopTimer];
    [confirmAlertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == insAlertView) {
        [self confirmAlertStartTimer];
    }
    else if (alertView == confirmAlertView){
        switch (buttonIndex) {
            case 0:[super backButtonPressed];break;
            case 1:[self confirmAlertStartTimer];break;
            default:break;
        }
    }
    else{
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

#pragma mark - Axis Rect

-(void)initAxis {
    for (int i=0; i<count_axis; i++) {
        [self.view addSubview:[self createViewWithTag:base_tag_x+i]];
        [self.view addSubview:[self createViewWithTag:base_tag_y+i]];
    }
}

-(UIView*)createViewWithTag:(int)tag{
    UIView *vw = [[UIView alloc]initWithFrame:[self getXRect:CGPointMake(0,0)]];
    vw.backgroundColor = [UIColor redColor];
    vw.tag = tag;
    vw.hidden = YES;
    return vw;
}

-(CGRect)getXRect:(CGPoint)point{
    return CGRectMake(point.x, point.y, self.view.frame.size.width, 1);
}
-(CGRect)getYRect:(CGPoint)point{
    return CGRectMake(point.x, point.y, 1, self.view.frame.size.height);
}

-(void)moveAxis:(int)tag withFrame:(CGRect)newFrame{
    ((UIView*)[self.view viewWithTag:tag]).frame = newFrame;
    ((UIView*)[self.view viewWithTag:tag]).hidden = NO;
}

-(void)axisViewStatus:(BOOL)isHidden withTag:(int)tag{
    ((UIView*)[self.view viewWithTag:tag]).hidden = isHidden;
}

-(void)hideUntouchAxis:(int)toucheIndex{
    while (toucheIndex<count_axis) {
        [self axisViewStatus:YES withTag:base_tag_x+toucheIndex];
        [self axisViewStatus:YES withTag:base_tag_y+toucheIndex];
        toucheIndex++;
    }
}

-(void)moveAxisWithTouch:(int)toucheIndex withTouchLocation:(CGPoint)touchLocation{
    [self moveAxis:base_tag_x+toucheIndex withFrame:[self getXRect:CGPointMake(0, touchLocation.y)]];
    [self moveAxis:base_tag_y+toucheIndex withFrame:[self getYRect:CGPointMake(touchLocation.x, 0)]];
}

#pragma mark - CellTouchDelegate

-(void)touchHappenAtCell:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!isMutitouchCheck && event.allTouches.count > 1) {
        [multitouchSuccessAlert show];
        isMutitouchCheck = YES;
        [self confirmAlertStopTimer];
        [super startTimer];
    }
    if (isMutitouchCheck) {
        int toucheIndex;
        for (toucheIndex=0; toucheIndex<event.allTouches.count; toucheIndex++) {
            UITouch *touch = event.allTouches.allObjects[toucheIndex];
            CGPoint touchLocation = [touch locationInView:super.touchCollectionView];
            [self moveAxisWithTouch:toucheIndex withTouchLocation:touchLocation];
            for (int cellIndex=0; cellIndex<=self.totalBlocks; cellIndex++) {
                VZTouchCollectionViewCell *cell = (VZTouchCollectionViewCell*)[super.touchCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
                if (CGRectContainsPoint(cell.frame, touchLocation)){
                    cell.vwTouchItem.backgroundColor = [UIColor blackColor];
                }
            }
        }
        [self hideUntouchAxis:toucheIndex];
        if ([super allBlockCheck]) {
            [super performSelector:@selector(backButtonPressed) withObject:nil afterDelay:1];
        }
    }
}

-(void)touchesEndAtCell:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideUntouchAxis:0];//if (event.allTouches.count==1) {[self hideUntouchAxis:0];}
}

@end
*/
