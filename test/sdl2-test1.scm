; simple SDL2 demo from sdl2-chicken 

(load (spheres/core base))
(load (spheres/sdl2 sdl2))

(SDL_Init SDL_INIT_EVERYTHING)
(define w (SDL_CreateWindow "HELLO" SDL_WINDOWPOS_UNDEFINED SDL_WINDOWPOS_UNDEFINED 200 200 0))
(SDL_ShowWindow w)
(define renderer (SDL_CreateRenderer w -1 0))
(SDL_SetRenderDrawBlendMode renderer SDL_BLENDMODE_NONE)
(SDL_SetRenderDrawColor renderer #xf0 #xa0 #x20 #xff)
(SDL_RenderClear renderer)

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

(draw-rects)
(SDL_RenderPresent renderer)

  (let loop ()
    (let ((e (alloc-SDL_Event)))
      (SDL_WaitEvent e)
      (unless (or
                (= (SDL_Event-type e) SDL_QUIT)
                (and
                  (= (SDL_Event-type e) SDL_KEYDOWN)
                  (= (SDL_Keysym-sym (SDL_KeyboardEvent-keysym (SDL_Event-key  e)))
		     SDLK_q))
                (and
                  (= (SDL_Event-type e) SDL_MOUSEBUTTONDOWN)
                  (= (SDL_MouseButtonEvent-button (SDL_Event-button e)) SDL_BUTTON_LEFT)))
	
	(loop))))

