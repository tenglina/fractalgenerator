.data
.balign 8
neg_1: .double -1
four: .double 4
two: .double 2
zero: .double 0

.text
.global ship

ship:
  stp x29, x30, [sp, #-16]!
  
  mov w3, #0   //num of iterations 

  xZero .req d0
  yZero .req d1

  x .req d2
  y .req d3
  
  ldr x0, =zero
  ldr d7, [x0]

  fmov x,d7 
  fmov y, d7

  //assigning 4.0 to d4 
  ldr x0, =four
  ldr d4, [x0]  

loop:
  cmp w3, #255
  bge loop_end
  
  //x**2 = d5
  fmul d5, x,x 
  
  //y**2 = d6
  fmul d6, y,y 

  fadd d7, d5, d6
  fcmp d7,d4
  bge loop_end 

  ldr x0, =zero
  ldr d7, [x0]

  fcmp x, d7
  blt neg_x
  
  fcmp y, d7
  blt neg_y

  b compute_new

neg_x:
  ldr x0, =neg_1
  ldr d7, [x0]

  fmul x, x, d7
  
  ldr x0, =zero
  ldr d7, [x0]
  fcmp y, d7
  blt neg_y

  b compute_new

neg_y:
  ldr x0, =neg_1
  ldr d7, [x0]
  fmul y, y, d7

compute_new:
  fmov d7, x
  fsub x, d5, d6   // x^2 - y^2
  fadd x, x, xZero    // x^2 -y^2 + x0

  fmul y, d7, y      //x*y
  ldr x0, =two
  ldr d7, [x0]
  fmul y, y, d7    //2*x*y
  fadd y, y, yZero
  
  add w3, w3, #1
  b loop
  
loop_end:
  mov w0,w3

ship_done:
  ldp x29, x30, [sp], #16
  ret

  .unreq x
  .unreq y
  .unreq xZero
  .unreq yZero

