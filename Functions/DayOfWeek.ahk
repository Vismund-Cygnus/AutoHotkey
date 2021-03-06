; Day-of-week code by Tomohiko Sakamoto
; Additional adjustments by Mordecai

DayOfWeek(time, stringResult = false)
{
    static t    := [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
        ,  days := ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

      y := SubStr(time, 1, 4)
    , m := SubStr(time, 5, 2)
    , d := SubStr(time, 7, 2)

    y -= (m < 3)

    dow := Mod(y + y // 4 - y // 100 + y // 400 + t[m] + d, 7)

    return (stringResult ? days[dow+1] : dow)
}