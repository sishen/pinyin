# coding: utf-8
$:.unshift "../lib"

require 'test/unit'
require 'pinyin'

class ChineseToPinyinTest < Test::Unit::TestCase
  def test_pinyin
    assert_equal("zhong", Chinese::Pronunciation.to_pinyin("中"))
    assert_equal("ss", Chinese::Pronunciation.to_pinyin("ss"))
    assert_equal("sszhong", Chinese::Pronunciation.to_pinyin("ss中"))
    assert_equal("zhongguo", Chinese::Pronunciation.to_pinyin("中国"))
    assert_equal('women', Chinese::Pronunciation.to_pinyin('我们'))
    assert_equal('womenenglishzifu', Chinese::Pronunciation.to_pinyin('我们english字符'))
    assert_equal('zhonghuarenmingongheguo', Chinese::Pronunciation.to_pinyin('中华人民共和国'))
    assert_equal('shidifen·huojin', Chinese::Pronunciation.to_pinyin('史蒂芬·霍金'))
    assert_equal('xinyue', Chinese::Pronunciation.to_pinyin('新约'))
  end
end
