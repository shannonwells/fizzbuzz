require 'rails_helper'
class TwilioTestClass
  include ::TwilioUtils
end

describe TwilioTestClass do
  let!(:klass){ TwilioTestClass.new }
  describe 'sorted_key_string' do
    let!(:some_hash){{
        'CallSid' => 'CA1234567890ABCDE',
        'To'=> '+18005551212',
        'cccc'=> 'dkdkdkd',
        'abcd'=> 'q234',
        'From'=> '+14158675309'
    }}
    subject { klass.sorted_key_string(some_hash)  }

    it 'works' do
      expected_result = 'CallSidCA1234567890ABCDEFrom+14158675309To+18005551212abcdq234ccccdkdkdkd'
      expect(subject).to eql expected_result
    end
  end

  # Using this example: https://www.twilio.com/docs/security
  describe 'signature_string' do
    let!(:some_hash){{
        'Digits' => '1234',
        'To'=> '+18005551212',
        'From' => '+14158675309',
        'Caller' => '+14158675309',
        'CallSid' => 'CA1234567890ABCDE'
    }}
    let!(:url){ 'https://mycompany.com/myapp.php?foo=1&bar=2'}
    let!(:secret) { '12345' }
    subject { klass.signature_string(secret, url, some_hash, true)}
    it 'works' do
      # remove the newline added by the Base64 encoding to compare
      expect(subject.chop).to eql 'RSOYDt4T1cUTdK1PDd93/VVr8B8='
    end
  end

end