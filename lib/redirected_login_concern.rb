module RedirectedLoginConcern
  extend ActiveSupport::Concern

  # Returns and delete the url stored in the stored_in object for
  # the given scope. Validates and returns only the URL's path and params
  # Useful for giving redirect backs after sign up:
  #
  # Example:
  #
  # redirect_to stored_location(params) || root_path
  #
  def stored_location(stored_in=session)
    uri = parse_uri(stored_in.delete(:referrer))
    if uri
      path = [uri.path.sub(/\A\/+/, '/'), uri.query].compact.join('?')
      path = [path, uri.fragment].compact.join('#')
      path
    else
      nil
    end
  end

  # Stores the provided full location to redirect the user after signing in.
  # Useful in combination with the `stored_location` method.
  #
  # Example:
  #
  # remember_location!
  # redirect_to login_path
  #
  def remember_location!(location=nil, store_in=session)
    location ||= request.url
    uri = parse_uri(location)
    if uri
      store_in[:referrer] = location
    end
    store_in
  end

private

  def parse_uri(location)
    uri = location && URI.parse(location)
    if %w(http https).include?(uri.try(:scheme))
      uri
    else
      raise URI::InvalidURIError
    end
  rescue URI::InvalidURIError
    nil
  end

end

