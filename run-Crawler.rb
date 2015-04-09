# encoding: utf-8 
class PttClient

require 'net/telnet'
require 'iconv'
WaitForInput =  '(?>\s+)(?>\x08+)'
AnsiSetDisplayAttr = '\x1B\[(?>(?>(?>\d+;)*\d+)?)m'
AnsiCursorHome = '\x1B\[(?>(?>\d+;\d+)?)H'
# '請按任意鍵繼續'    
PressAnyKey = '\xAB\xF6\xA5\xF4\xB7\x4E\xC1\xE4\xC4\x7E\xC4\xF2'
# '請按任意鍵繼續 ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄'
PressAnyKeyToContinue = "#{PressAnyKey}(?>\\s*)#{AnsiSetDisplayAttr}(?>(?:\\xA2\\x65)+)\s*#{AnsiSetDisplayAttr}"
Big5Code = '[\xA1-\xF9][\x40-\xF0]'

tn = Net::Telnet.new('Host'       => "ptt.cc", 
                     'Port'       => 23,       
                     'Timeout'    => 5,        
                     'Waittime'   => 1         
                    )
b2u = Iconv.new("UTF8//IGNORE","BIG5")
tn.waitfor(/guest.+new(?>[^:]+):(?>\s*)#{AnsiSetDisplayAttr}#{WaitForInput}\Z/){ 
    |s| print(b2u.iconv(s).force_encoding("UTF-8"))
}

strTmpPattern = '/\xB1\x4B\xBD\x58:(?>\s*)\Z/'
regPasswd = Regexp.new strTmpPattern, nil, 'n'

tn.cmd( 'String' => ARGV[0],  
        'Match'  => regPasswd) { 
    |s| print(s)
}   

end #endcalss
