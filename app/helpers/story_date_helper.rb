module StoryDateHelper
  
  def parsePrecision(precision)
    case  precision
      when 'MINUTE'
        :min_base
      when 'HOUR'
        :hour_base
      when 'DAY'
        :day_base
      when 'MONTH'
        :mth_base
      when 'YEAR'
        :year_base
      when 'DECADE'
        :dec_base
      when 'AGE'
        :age_base
    end
  end
  
  def getPrecision(precision)
    case precision
      when :min_base
        'MINUTE'
      when :hour_base
        'HOUR'
      when :day_base
        'DAY'
      when :mth_base
        'MONTH'
      when :year_base
        'YEAR'
      when :dec_base
        'DECADE'
      when :age_base
        'AGE'
    end
  end
  
  def getBottomBoundry(precision)
     case precision
      when :min_base
        'MINUTE'
      when :hour_base
        'HOUR'
      when :day_base
        'DAY'
      when :mth_base
        'MONTH'
      when :year_base
        'YEAR'
      when :dec_base
        'DECADE'
      when :age_base
        'AGE'
    end
  end
     
  def getTopBoundry(precision)
     case precision
      when :min_base
        'MINUTE'
      when :hour_base
        'HOUR'
      when :day_base
        'DAY'
      when :mth_base
        'MONTH'
      when :year_base
        'YEAR'
      when :dec_base
        'DECADE'
      when :age_base
        'AGE'
    end
  end
  
  def getSkip(precision)
    case  precision
      when :min_base
        1
      when :hour_base
        100
      when :day_base
        10000
      when :mth_base
        1000000
      when :year_base
        100000000
      when :dec_base
        1000000000
      when :age_base
        10000000000
      when 'MINUTE'
        1
      when 'HOUR'
        100
      when 'DAY'
        10000
      when 'MONTH'
        1000000
      when 'YEAR'
        100000000
      when 'DECADE'
        1000000000
      when 'AGE'
        10000000000
    end
  end
  
  def getDivisor(precision)
    case  precision
      when :min_base
        100
      when :hour_base
        10000
      when :day_base
        1000000
      when :mth_base
        100000000
      when :year_base
        10000000000
      when :dec_base
        100000000000
      when :age_base
        1000000000000
      when 'MINUTE'
        100
      when 'HOUR'
        10000
      when 'DAY'
        1000000
      when 'MONTH'
        100000000
      when 'YEAR'
        10000000000
      when 'DECADE'
        100000000000
      when 'AGE'
        1000000000000
    end
  end
  
  def isLeapYear(year)
    leap = false
    if((year%4==0 && year%100!=0) || year%400==0)
      leap = true
    end
    leap    
  end
  
  def getDaysCount(month, isLeapYear)
    val = 0
    case month
      when 1,3,5,7,8,10,12
        val=31
      when 4,6,9,11
        val=30
      when 2
        if isLeapYear
          val=29
        else
          val=28  
        end
    end
    val  
  end
  
  def parseDate(date)
    all = date
    wtf = 0
    if(date>0)
      wtf = 1
    else
      wtf = -1
    end
    
    if((date = date.abs)<100000000)
       #raise "ILLEGAL STORY DATE PROCCESED #{all}"
    end
      
    minutes = date%100
    date /= 100
    hours = date%100
    date/=100    
    days = date%100
    date  /= 100
    months=date%100
    date=date/100
    
    years = date
    
    decade = years/10
    decade %= 10
    
    age = years/100
    agePlus = years%100
    if(agePlus!=0)
      age+=1
    end
    
    form = (wtf>0?"":"-")+years.to_s+"."+(months<10?"0":"")+months.to_s+"."+(days<10?"0":"")+days.to_s+" "+(hours<10?"0":"")+hours.to_s+":"+(minutes<10?"0":"")+minutes.to_s
    
    hash = { form: form, date: all, minutes: minutes, hours: hours, days: days, months: months, years: years, c: wtf, isLeap: isLeapYear(years), decade: decade, age: age}
    string  = toString(hash, "MINUTE")
    hash[:string] = string
    hash
  end
  
  
  
  def getMonth(mth)
    case(mth)
      when 1
        "JANUARY"
      when 2
        "FEBRUARY"
      when 3
        "MARCH"
      when 4
        "APRIL"
      when 5
        "MAY"
      when 6
        "JUNE"
      when 7
        "JULY"
      when 8
        "AUGUST"
      when 9
        "SEPTEMBER"
      when 10
        "NOVEMBER"
      when 11
        "OCTOBER"
      when 12
        "DECEMBER"
    end
  end
  
  def addTimeUnit(parsedTime, precision)
    case(parsePrecision(precision))
      when :min_base
        newDate(parsedTime[:years]*parsedTime[:c],parsedTime[:months],parsedTime[:days],parsedTime[:hours],parsedTime[:minutes]+1)
      when :hour_base
        newDate(parsedTime[:years]*parsedTime[:c],parsedTime[:months],parsedTime[:days],parsedTime[:hours]+1,parsedTime[:minutes])
      when :day_base
        newDate(parsedTime[:years]*parsedTime[:c],parsedTime[:months],parsedTime[:days]+1,parsedTime[:hours],parsedTime[:minutes])
      when :mth_base
        newDate(parsedTime[:years]*parsedTime[:c],parsedTime[:months]+1,parsedTime[:days],parsedTime[:hours],parsedTime[:minutes])
      when :year_base
        newDate(parsedTime[:years]*parsedTime[:c]+1,parsedTime[:months],parsedTime[:days],parsedTime[:hours],parsedTime[:minutes])
      when :dec_base
        newDate(parsedTime[:years]*parsedTime[:c]+10,parsedTime[:months],parsedTime[:days],parsedTime[:hours],parsedTime[:minutes])
      when :age_base
        newDate(parsedTime[:years]*parsedTime[:c]+100,parsedTime[:months],parsedTime[:days],parsedTime[:hours],parsedTime[:minutes])
    end
  end
  
  def toString(parsedTime, precision)
    case(parsePrecision(precision))
      when :min_base
        tmp = ""
        tmp = tmp + parsedTime[:years].to_s
        if(parsedTime[:c]>0)
          tmp = tmp + " A.C. "
        else
          tmp = tmp + " B.C. "
        end
        tmp += parsedTime[:days].to_s + " "
        tmp = tmp + getMonth(parsedTime[:months]).to_s + " "
        tmp += parsedTime[:hours].to_s + ":" + parsedTime[:minutes].to_s
        tmp
      when :hour_base
        tmp = ""
        tmp = tmp + parsedTime[:years].to_s
        if(parsedTime[:c]>0)
          tmp = tmp + " A.C. "
        else
          tmp = tmp + " B.C. "
        end
        tmp += parsedTime[:days].to_s + " "
        tmp = tmp + getMonth(parsedTime[:months]) + " "
        tmp += parsedTime[:hours].to_s + " hour"
        tmp
      when :day_base
        tmp = ""
        tmp = tmp + parsedTime[:years].to_s
        if(parsedTime[:c]>0)
          tmp = tmp + " A.C. "
        else
          tmp = tmp + " B.C. "
        end
        tmp += parsedTime[:days].to_s + " "
        tmp = tmp + getMonth(parsedTime[:months])
        tmp
      when :mth_base
        tmp = ""
        tmp = tmp + parsedTime[:years].to_s
        if(parsedTime[:c]>0)
          tmp = tmp + " A.C. "
        else
          tmp = tmp + " B.C. "
        end
        tmp = tmp + getMonth(parsedTime[:months]) + " "
        tmp
      when :year_base
        tmp = ""
        tmp = tmp + parsedTime[:years].to_s
        if(parsedTime[:c]>0)
          tmp = tmp + " A.C. "
        else
          tmp = tmp + " B.C. "
        end
      when :dec_base
        tmp = ""
        tmp = tmp + parsedTime[:age].to_s + " age "
        tmp = tmp + parsedTime[:decade].to_s + " decade"
        if(parsedTime[:c]>0)
          tmp = tmp + " A.C. "
        else
          tmp = tmp + " B.C. "
        end
        tmp
      when :age_base
        tmp = ""
        tmp = tmp + parsedTime[:age].to_s + " age "
        if(parsedTime[:c]>0)
          tmp = tmp + " A.C. "
        else
          tmp = tmp + " B.C. "
        end
        tmp
      else
        "my bad"
    end
  end
  
  
  
  def newDate(year,month,day,hour,minute) 
    if(minute>59)
      minute=0
      hour+=1
    end
    if(hour>23)
      hour=0
      day+=1
    end
    isLeap = isLeapYear(year.abs)
    if(day>getDaysCount(month,isLeap))
      day=1
      month+=1
    end
    if(month>12)
      month=1
      year+=1
    end
    
    if(year==0)
      year+=1
    end
    ac = 1
    ac = -1 if year<0
    parseDate((year.abs*100000000+month*1000000+day*10000+hour*100+minute)*ac)
  end
  
  def validateDate(date)
    valid = true
    if date[:minutes]>59
      valid = false
    elsif date[:hours]>23
      valid = false
    elsif date[:years] == 0 
      valid = false
    elsif date[:months]>12 || date[:months] == 0
      valid = false
    elsif date[:days] > getDaysCount(date[:months],isLeapYear(date[:years])) || date[:days]==0
      valid = false    
    end
    valid
  end
  
  
  
end