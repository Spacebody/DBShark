--
-- Query contributed by 刘丝雨 (LIU Siyu)
--
function hasRepeat(objId,columnIndex){
     var arr = []
     $("#"+objId+" tbody tr").each(function(){
        arr.push( $("td:eq("+columnIndex+")",this).text() );
     })
     if( arr.length==$.unique( arr ).length ){
        return false
     }else{
        return true
     }
}