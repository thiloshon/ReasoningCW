MACHINE SpaceShipTemp

SETS KEY

VARIABLES keys_in, astroids

INVARIANT keys_in <: KEY & 
                astroids : NAT1 <-> NAT1 /* Set of keys */

INITIALISATION keys_in := {} || astroids := {   (3,2), 
                                (3,5), 
                                (5,4), 
                                (6,4),  
                                (6,7),  
                                (7,1),  
                                (7,5),  
                                (7,7),  
                                (8,3),  
                                (10,6),  
                                (11,2),  
                                (12,5)} 
    
 

OPERATIONS

hits <-- hits_astroid(x, y) =
IF ( y : ran({x} <| astroids) )
THEN
hits :=  TRUE
ELSE
hits := FALSE
END ;



ans <-- move =
BEGIN
temp;
    IF (card(astroids) > 6)
THEN
        ans :=  TRUE
    ELSE
        ans := FALSE
END
END ;



temp =
IF ( card(astroids) > 6 )
THEN
keys_in :=  right_key
ELSE
keys_in := left_key
END


END /* Keys */