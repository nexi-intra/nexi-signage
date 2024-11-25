import moment from "moment";
import _ from "lodash"





function todayHourMinute(h,m){
    var date = moment()
    date .set('hour',h)
    date .set('minute',m)
}
function booking(fromH,fromM,toH,toM,oranizer){

return {
    start : todayHourMinute(fromH,fromM),
    end : todayHourMinute(toH,toM)

}
}
export function mockBooking(){

    var bookings = []
    bookings.push()
}
function time(exchangeTime){
    return moment.tz(exchangeTime.dateTime,exchangeTime.timeZone)
}
export function getCurrentBookingStatus(bookings,now){
    var isAvailable, availableFrom,availableTo,currentBooking,nextBooking 

    isAvailable = true
  

    var startOfToday = moment(now).startOf("day").toISOString();
    var endOfToday = moment(now).endOf("day").toISOString();

    availableFrom = moment(now)
    availableTo = endOfToday

//    bookings =  _.sortBy(bookings,[(o)=>{return o.start.dateTime}])
    var foundCurrentBooking = false
    bookings.forEach(booking => {
        var bookedFrom =time(booking.start)
        var bookedTo = time(booking.end)
        
        if (!nextBooking && moment(bookedFrom).isAfter(moment())){
            nextBooking = booking
            availableTo = time(booking.start)
        }   
                     

        if (moment(now).isBetween(bookedFrom,bookedTo)){
            isAvailable = false
            currentBooking = booking
            availableFrom = time(booking.end)
            
        }
        
    });
    


return [isAvailable,availableFrom,availableTo,currentBooking,nextBooking ]
}


export function slots24hour(bookings){

    const status = (hour,minute) => {

        
        var busy = false
        var slotTime =  moment().startOf("day").add(hour,'h').add(minute,'m')
        bookings.forEach(booking => {

            var bookedFrom =time(booking.start)
            var bookedTo = time(booking.end)
            
    
    
            if (slotTime.isBetween(bookedFrom,bookedTo)){
               busy = true
                
            }
           
        });
        return busy ? "busy":"free"
    }
    var slots = []
    for (let hour = 7; hour  < 18; hour++) {
        for (let min = 0; min < 60; min+=15) {
            slots.push({hour,min,bookings:[],status:status(hour,min)})


            
        }
    }

    return slots    


}