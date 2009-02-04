require 'iconv'
$KCODE = 'u'

class Chinese
  class UnsupportedChineseError < StandardError; end

  class Pronunciation
    # GB2312 Character code table
    # http://ash.jp/code/cn/gb2312tbl.htm
    @@SpellList = [
                   0xB0A1 , 0xB0A3 , 0xB0B0 , 0xB0B9 , 0xB0BC , 0xB0C5 , 0xB0D7 , 0xB0DF , 0xB0EE ,
                   0xB0FA , 0xB1AD , 0xB1BC , 0xB1C0 , 0xB1DE , 0xB1EA , 0xB1EE , 0xB1F2 , 0xB1F8 ,
                   0xB2A3 , 0xB2B8 , 0xB2C1 , 0xB2C2 , 0xB2C2 , 0xB2CD , 0xB2D4 , 0xB2D9 , 0xB2DE ,
                   0xB2E3 , 0xB2E5 , 0xB2F0 , 0xB2F3 , 0xB2FD , 0xB3AC , 0xB3B5 , 0xB3BB , 0xB3C5 ,
                   0xB3D4 , 0xB3E4 , 0xB3E9 , 0xB3F5 , 0xB4A7 , 0xB4A8 , 0xB4AF , 0xB4B5 , 0xB4BA ,
                   0xB4C1 , 0xB4CF , 0xB4D5 , 0xB4D6 , 0xB4DA , 0xB4DD , 0xB4E5 , 0xB4E8 , 0xB4EE ,
                   0xB4F4 , 0xB5A2 , 0xB5B1 , 0xB5B6 , 0xB5C2 , 0xB5C5 , 0xB5CC, 0xB5DF , 0xB5EF , 0xB5F8 ,
                   0xB6A1 , 0xB6AA , 0xB6AB , 0xB6B5 , 0xB6BC , 0xB6CB , 0xB6D1 , 0xB6D5 , 0xB6DE ,
                   0xB6F7 , 0xB6F8 , 0xB7A2 , 0xB7AA , 0xB7BB , 0xB7C6 , 0xB7D2 , 0xB7E1 , 0xB7F0 ,
                   0xB7F1 , 0xB7F2 , 0xB8C1 , 0xB8C3 , 0xB8C9 , 0xB8D4 , 0xB8DD , 0xB8E7 , 0xB8F8 ,
                   0xB8F9 , 0xB8FB , 0xB9A4 , 0xB9B3 , 0xB9BC , 0xB9CE , 0xB9D4 , 0xB9D7 , 0xB9E2 ,
                   0xB9E5 , 0xB9F5 , 0xB9F8 , 0xB9FE , 0xBAA1 , 0xBAA8 , 0xBABB , 0xBABE , 0xBAC7 ,
                   0xBAD9 , 0xBADB , 0xBADF , 0xBAE4 , 0xBAED , 0xBAF4 , 0xBBA8 , 0xBBB1 , 0xBBB6 ,
                   0xBBC4 , 0xBBD2 , 0xBBE7 , 0xBBED , 0xBBF7 , 0xBCCE , 0xBCDF , 0xBDA9 , 0xBDB6 ,
                   0xBDD2 , 0xBDED , 0xBEA3 , 0xBEBC , 0xBEBE , 0xBECF , 0xBEE8 , 0xBEEF , 0xBEF9 ,
                   0xBFA6 , 0xBFAA , 0xBFAF , 0xBFB5 , 0xBFBC , 0xBFC0 , 0xBFCF , 0xBFD3 , 0xBFD5 ,
                   0xBFD9 , 0xBFDD , 0xBFE4 , 0xBFE9 , 0xBFED , 0xBFEF , 0xBFF7 , 0xC0A4 , 0xC0A8 ,
                   0xC0AC , 0xC0B3 , 0xC0B6 , 0xC0C5 , 0xC0CC , 0xC0D5 , 0xC0D7 , 0xC0E2 , 0xC0E5 ,
                   0xC1A9 , 0xC1AA , 0xC1B8 , 0xC1C3 , 0xC1D0 , 0xC1D5 , 0xC1E1 , 0xC1EF , 0xC1FA ,
                   0xC2A5 , 0xC2AB , 0xC2BF , 0xC2CD , 0xC2D3 , 0xC2D5 , 0xC2DC , 0xC2E8 , 0xC2F1 ,
                   0xC2F7 , 0xC3A2 , 0xC3A8 , 0xC3B4 , 0xC3B5 , 0xC3C5 , 0xC3C8 , 0xC3D0 , 0xC3DE ,
                   0xC3E7 , 0xC3EF , 0xC3F1 , 0xC3F7 , 0xC3FD , 0xC3FE , 0xC4B1 , 0xC4B4 , 0xC4C3 ,
                   0xC4CA , 0xC4CF , 0xC4D2 , 0xC4D3 , 0xC4D8 , 0xC4D9 , 0xC4DB , 0xC4DC , 0xC4DD ,
                   0xC4E8 , 0xC4EF , 0xC4F1 , 0xC4F3 , 0xC4FA , 0xC4FB , 0xC5A3 , 0xC5A7 , 0xC5AB ,
                   0xC5AE , 0xC5AF , 0xC5B0 , 0xC5B2 , 0xC5B6 , 0xC5B7 , 0xC5BE , 0xC5C4 , 0xC5CA ,
                   0xC5D2 , 0xC5D7 , 0xC5DE , 0xC5E7 , 0xC5E9 , 0xC5F7 , 0xC6AA , 0xC6AE , 0xC6B2 ,
                   0xC6B4 , 0xC6B9 , 0xC6C2 , 0xC6CB , 0xC6DA , 0xC6FE , 0xC7A3 , 0xC7B9 , 0xC7C1 ,
                   0xC7D0 , 0xC7D5 , 0xC7E0 , 0xC7ED , 0xC7EF , 0xC7F7 , 0xC8A6 , 0xC8B1 , 0xC8B9 ,
                   0xC8BB , 0xC8BF , 0xC8C4 , 0xC8C7 , 0xC8C9 , 0xC8D3 , 0xC8D5 , 0xC8D6 , 0xC8E0 ,
                   0xC8E3 , 0xC8ED , 0xC8EF , 0xC8F2 , 0xC8F4 , 0xC8F6 , 0xC8F9 , 0xC8FD , 0xC9A3 ,
                   0xC9A6 , 0xC9AA , 0xC9AD , 0xC9AE , 0xC9AF , 0xC9B8 , 0xC9BA , 0xC9CA , 0xC9D2 ,
                   0xC9DD , 0xC9E9 , 0xC9F9 , 0xCAA6 , 0xCAD5 , 0xCADF , 0xCBA2 , 0xCBA4 , 0xCBA8 ,
                   0xCBAA , 0xCBAD , 0xCBB1 , 0xCBB5 , 0xCBB9 , 0xCBC9 , 0xCBD1 , 0xCBD4 , 0xCBE1 ,
                   0xCBE4 , 0xCBEF , 0xCBF2 , 0xCBFA , 0xCCA5 , 0xCCAE , 0xCCC0 , 0xCCCD , 0xCCD8 ,
                   0xCCD9 , 0xCCEC , 0xCCF4 , 0xCCF9 , 0xCCFC , 0xCDA8 , 0xCDB5 , 0xCDB9 , 0xCDC4 ,
                   0xCDC6 , 0xCDCC , 0xCDCF , 0xCDDA , 0xCDE1 , 0xCDE3 , 0xCDF4 , 0xCDFE , 0xCEC1 ,
                   0xCECB , 0xCECE , 0xCED7 , 0xCEF4 , 0xCFB9 , 0xCFC6 , 0xCFE0 , 0xCFF4 , 0xD0A8 ,
                   0xD0BD , 0xD0C7 , 0xD0D6 , 0xD0DD , 0xD0E6 , 0xD0F9 , 0xD1A5 , 0xD1AB , 0xD1B9 ,
                   0xD1C9 , 0xD1EA , 0xD1FB , 0xD2AC , 0xD2BB , 0xD2F0 , 0xD3A2 , 0xD3B4 , 0xD3B5 ,
                   0xD3C4 , 0xD3D9 , 0xD4A7 , 0xD4BB , 0xD4C5 , 0xD4D1 , 0xD4D4 , 0xD4DB , 0xD4DF ,
                   0xD4E2 , 0xD4F0 , 0xD4F4 , 0xD4F5 , 0xD4F6 , 0xD4FA , 0xD5AA , 0xD5B0 , 0xD5C1 ,
                   0xD5D0 , 0xD5DA , 0xD5E4 , 0xD5F4 , 0xD6A5 , 0xD6D0 , 0xD6DB , 0xD6E9 , 0xD7A5 ,
                   0xD7A7 , 0xD7A8 , 0xD7AE , 0xD7B5 , 0xD7BB , 0xD7BD , 0xD7C8 , 0xD7D7 , 0xD7DE ,
                   0xD7E2 , 0xD7EA , 0xD7EC , 0xD7F0 , 0xD7F2
                  ]
    @@Pronunciation = [
                       "a" , "ai" , "an" , "ang" , "ao" , "ba" , "bai" , "ban" , "bang" ,
                       "bao" , "bei" , "ben" , "beng" , "bian" , "biao" , "bie" , "bin" , "bing" ,
                       "bo" , "bu" , "ca" , "cai" , "cai" , "can" , "cang" , "cao" , "ce" ,
                       "ceng" , "cha" , "chai" , "chan" , "chang" , "chao" , "che" , "chen" , "cheng" ,
                       "chi" , "chong" , "chou" , "chu" , "chuai" , "chuan" , "chuang" , "chui" , "chun" ,
                       "chuo" , "cong" , "cou" , "cu" , "cuan" , "cui" , "cun" , "cuo" , "da" ,
                       "dai" , "dan" , "dang" , "dao" , "de" , "deng" , "di", "dian" , "diao" , "die" ,
                       "ding" , "diu" , "dong" , "dou" , "du" , "duan" , "dui" , "dun" , "duo" ,
                       "en" , "er" , "fa" , "fan" , "fang" , "fei" , "fen" , "feng" , "fo" ,
                       "fou" , "fu" , "ga" , "gai" , "gan" , "gang" , "gao" , "ge" , "gei" ,
                       "gen" , "geng" , "gong" , "gou" , "gu" , "gua" , "guai" , "guan" , "guang" ,
                       "gui" , "gun" , "guo" , "ha" , "hai" , "han" , "hang" , "hao" , "he" ,
                       "hei" , "hen" , "heng" , "hong" , "hou" , "hu" , "hua" , "huai" , "huan" ,
                       "huang" , "hui" , "hun" , "huo" , "ji" , "jia" , "jian" , "jiang" , "jiao" ,
                       "jie" , "jin" , "jing" , "jiong" , "jiu" , "ju" , "juan" , "jue" , "jun" ,
                       "ka" , "kai" , "kan" , "kang" , "kao" , "ke" , "ken" , "keng" , "kong" ,
                       "kou" , "ku" , "kua" , "kuai" , "kuan" , "kuang" , "kui" , "kun" , "kuo" ,
                       "la" , "lai" , "lan" , "lang" , "lao" , "le" , "lei" , "leng" , "li" ,
                       "lia" , "lian" , "liang" , "liao" , "lie" , "lin" , "ling" , "liu" , "long" ,
                       "lou" , "lu" , "lv" , "luan" , "lue" , "lun" , "luo" , "ma" , "mai" ,
                       "man" , "mang" , "mao" , "me" , "mei" , "men" , "meng" , "mi" , "mian" ,
                       "miao" , "mie" , "min" , "ming" , "miu" , "mo" , "mou" , "mu" , "na" ,
                       "nai" , "nan" , "nang" , "nao" , "ne" , "nei" , "nen" , "neng" , "ni" ,
                       "nian" , "niang" , "niao" , "nie" , "nin" , "ning" , "niu" , "nong" , "nu" ,
                       "nv" , "nuan" , "nue" , "nuo" , "o" , "ou" , "pa" , "pai" , "pan" ,
                       "pang" , "pao" , "pei" , "pen" , "peng" , "pi" , "pian" , "piao" , "pie" ,
                       "pin" , "ping" , "po" , "pu" , "qi" , "qia" , "qian" , "qiang" , "qiao" ,
                       "qie" , "qin" , "qing" , "qiong" , "qiu" , "qu" , "quan" , "que" , "qun" ,
                       "ran" , "rang" , "rao" , "re" , "ren" , "reng" , "ri" , "rong" , "rou" ,
                       "ru" , "ruan" , "rui" , "run" , "ruo" , "sa" , "sai" , "san" , "sang" ,
                       "sao" , "se" , "sen" , "seng" , "sha" , "shai" , "shan" , "shang" , "shao" ,
                       "she" , "shen" , "sheng" , "shi" , "shou" , "shu" , "shua" , "shuai" , "shuan" ,
                       "shuang" , "shui" , "shun" , "shuo" , "si" , "song" , "sou" , "su" , "suan" ,
                       "sui" , "sun" , "suo" , "ta" , "tai" , "tan" , "tang" , "tao" , "te" ,
                       "teng" , "tian" , "tiao" , "tie" , "ting" , "tong" , "tou" , "tu" , "tuan" ,
                       "tui" , "tun" , "tuo" , "wa" , "wai" , "wan" , "wang" , "wei" , "wen" ,
                       "weng" , "wo" , "wu" , "xi" , "xia" , "xian" , "xiang" , "xiao" , "xie" ,
                       "xin" , "xing" , "xiong" , "xiu" , "xu" , "xuan" , "xue" , "xun" , "ya" ,
                       "yan" , "yang" , "yao" , "ye" , "yi" , "yin" , "ying" , "yo" , "yong" ,
                       "you" , "yu" , "yuan" , "yue" , "yun" , "za" , "zai" , "zan" , "zang" ,
                       "zao" , "ze" , "zei" , "zen" , "zeng" , "zha" , "zhai" , "zhan" , "zhang" ,
                       "zhao" , "zhe" , "zhen" , "zheng" , "zhi" , "zhong" , "zhou" , "zhu" , "zhua" ,
                       "zhuai" , "zhuan" , "zhuang" , "zhui" , "zhun" , "zhuo" , "zi" , "zong" , "zou" ,
                       "zu" , "zuan" , "zui" , "zun" , "zuo"
                      ]

    @@Chinese_Unicode_Start = 19968
    @@Chinese_Unicode_End = 40869

    @@UCS2_TO_GB2312 = Iconv.new("GB2312//IGNORE", "UCS-2//IGNORE")

    class << self
      # get the pronunciation of the chinese
      def to_pinyin(chinese)
        array = chinese.unpack("U*")

        pinyin = array.inject("") do |pinyin, integer|
          if isChineseUnicode(integer)
            pinyin += to_Pronunciation(integer)
          else
            pinyin += [integer].pack("U")
          end
          pinyin
        end
        pinyin.strip!
        pinyin
      end
      alias :getPronunciation :to_pinyin

      private

      def isChineseUnicode(integer)
        return integer >= @@Chinese_Unicode_Start && integer <= @@Chinese_Unicode_End
      end

      def to_Pronunciation(integer)
        ucs2_string = [integer%256, integer/256].collect {|n| n.chr}.to_s
        gb_string = @@UCS2_TO_GB2312.iconv(ucs2_string)
        raise UnsupportedChineseError if gb_string.empty?
        gbnum = gb_string[0]*256 + gb_string[1]
        spell_idx = bsearch(gbnum)
        @@Pronunciation[spell_idx]
      end

      def bsearch(integer)
        lower = 0
        upper = @@SpellList.length

        while lower + 1 != upper
          mid = ((lower + upper) / 2).to_i
          if (@@SpellList[mid] < integer)
            lower = mid
          elsif @@SpellList[mid] == integer
            return mid
          else
            upper = mid
          end
        end
        return upper-1
      end
    end
  end
end
