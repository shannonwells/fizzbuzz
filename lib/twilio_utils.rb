module TwilioUtils

  def signature_string(secret, url, params={}, is_post=false)
    return nil unless secret && url && params
    digest = OpenSSL::Digest.new('sha1')
    data = url
    if is_post
      data << sorted_key_string(params)
    end
    Base64.encode64(OpenSSL::HMAC.digest(digest, secret, data))
  end

  def sorted_key_string(from_hash)
    sorted_keys = from_hash.keys.sort # this does obey Unix sorting rules
    sorted_keys.reduce('') { |keystring, value| keystring << "#{value}#{from_hash[value]}" }
  end

end