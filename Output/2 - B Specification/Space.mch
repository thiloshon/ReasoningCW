/* ***********************************************
** 6SENG001W Reasoning About Programs Coursework
** Spaceship & Asteroids
**
** Component: Space
** Author:    Thiloshon
** Created:   24-Dec-18
** Modified:  31-Dec-18
*********************************************** */
MACHINE
    Space
    
CONSTANTS       
    xRegion,
    yRegion,
    space
    
PROPERTIES    
    xRegion <: NATURAL1 & xRegion =  1 .. 12  & // or can use xMin, xMax
    yRegion <: NATURAL1 & yRegion =  1 .. 7  &
    space : SPACE & space = xRegion * yRegion 
    
DEFINITIONS
    strikes_boundry(x, y) == ( x /: xRegion or y /: yRegion ); 
    SPACE == POW(NATURAL1 * NATURAL1) 
    
END

    
//    ans <-- is_a_boundry(xNew, yNew) = 
//    PRE
//        xNew : NATURAL1 & yNew : NATURAL1 
//    THEN        
//        IF (strikes_boundry(xNew, yNew))
//        THEN
//            ans := TRUE
//        ELSE
//            ans := FALSE
//        END        
//    END