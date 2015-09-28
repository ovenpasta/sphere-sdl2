; simple SDL2 demo from sdl2-chicken 

(load (spheres/core base))
(load (spheres/sdl2 sdl2))

(define window #f)
(define renderer #f)

(define (init)
  
  (unless (= 0 (SDL_Init SDL_INIT_VIDEO))
    (error "SDL initialization failed."))

  (set! window (SDL_CreateWindow "HELLO" SDL_WINDOWPOS_UNDEFINED SDL_WINDOWPOS_UNDEFINED 800 450 0))
  (if (eq? #f window) 
      (error "Window creation failed."))

  (SDL_ShowWindow window)
  
  (set! renderer (SDL_CreateRenderer window -1 0))
  (if (eq? #f renderer) 
      (error "Render creation failed."))

  (SDL_SetRenderDrawBlendMode renderer SDL_BLENDMODE_NONE)
  (SDL_SetRenderDrawColor renderer #xf0 #xa0 #x20 #xff)
  (SDL_RenderClear renderer))

(define (draw-rects)
  (define viewport* (alloc-SDL_Rect))
  (SDL_RenderGetViewport renderer viewport*)
  (SDL_SetRenderDrawColor renderer #xff #xff #xff #xff)
  (let loop
    ((i 0))
    (if (< i 100)
      (let ((rect* (alloc-SDL_Rect)))
	(SDL_Rect-x-set! rect* i)
	(SDL_Rect-y-set! rect* i)
	(SDL_Rect-h-set! rect* 10)
	(SDL_Rect-w-set! rect* 10)
        (SDL_RenderFillRect renderer rect*)
        (loop (+ i 10))))))

(define (quit)
  (SDL_DestroyWindow window)
  (SDL_DestroyRenderer renderer)
  (SDL_Quit))

(define (main)
  (init)
  
  (draw-rects)

  ; Update the screen.
  (SDL_RenderPresent renderer)

  (let loop ()
    (let ((e (alloc-SDL_Event)))
      (if (= 1 (SDL_WaitEvent e))      
	  (unless (or
		   (= (SDL_Event-type e) SDL_QUIT)
		   (and
		    (= (SDL_Event-type e) SDL_KEYDOWN)
		    (= (SDL_Keysym-sym (SDL_KeyboardEvent-keysym (SDL_Event-key  e)))
		       SDLK_q))
		   (and
		    (= (SDL_Event-type e) SDL_MOUSEBUTTONDOWN)
		    (= (SDL_MouseButtonEvent-button (SDL_Event-button e)) SDL_BUTTON_LEFT)))
	    
	    (loop)))))
  (quit))

(main)


