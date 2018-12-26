/* Space
* Author: Thiloshon
* Creation date: 24-Dec-18
*/
MACHINE
    Space
    
CONSTANTS       
    xMin,
    xMax,
    yMin,
    yMax
    
PROPERTIES    
    xMax : NATURAL1 & xMax = 12 & // mkae into range
    yMax : NATURAL1 & yMax = 7 &
    xMin : NATURAL1 & xMin = 1 &
    yMin : NATURAL1 & yMin = 1 
    
    
DEFINITIONS
    strikes_boundry(x, y) == ( x /: xMin .. xMax or y /: yMin .. yMax )
    
OPERATIONS

    ans <-- is_a_boundry(xNew, yNew) = 
    PRE
        xNew : NATURAL1 & yNew : NATURAL1 
    THEN        
        IF (strikes_boundry(xNew, yNew))
        THEN
            ans := TRUE
        ELSE
            ans := FALSE
        END        
    END
END
