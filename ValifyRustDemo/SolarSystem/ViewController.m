#import "ViewController.h"
#import "rs_gl_test.h"

@interface ViewController () {
    struct GLProgramWrapper * _wrapper;
}
@property(strong, nonatomic) EAGLContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _setupEGLContext];
    _wrapper = rust_opengl_backend_init();
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [EAGLContext setCurrentContext:self.context];
    [view bindDrawable];
    
    // ----------- issue your draw call
    rust_opengl_backend_draw(_wrapper);
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

@end
