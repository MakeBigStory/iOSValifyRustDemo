#import "ViewController.h"
#import "rs_gl_test.h"

@interface ViewController ()
@property(strong, nonatomic) EAGLContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _setupEGLContext];
}

- (void)_setupEGLContext {
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!self.context) {
        NSLog(@"Failed to create ES context, no need to continue");
        exit(0);
    }
    
    GLKView *view = (GLKView *) self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    
//    init_env_rs();
}

- (void)dealloc {
    [self _tearDownGL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        [self _tearDownGL];
        
        self.context = nil;
        self.view = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)_tearDownGL {
    [EAGLContext setCurrentContext:self.context];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [EAGLContext setCurrentContext:self.context];
    [view bindDrawable];
    
    // ----------- issue your draw call
    init_env_rs();
}

@end
