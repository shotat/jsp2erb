require "jsp2erb/version"

module Jsp2erb
  def self.convert(data)
    data
      .gsub(/<c:set\s+var=\"([^\"]+)\">([^<]+)<\/c:set>/, '<% \1 = "\2" # TODO: c:set %>')
      .gsub(/<%--\s+([^\s]+)\s+--%>/, '<%# \1 %>')
      .gsub(/<tiles:put\s+name=\"([^\"]+)\"\s+value=\"([^\"]+)\"\s+\/>/, '<% content_for :\1 do # TODO: tiles:put single %>\2<% end %>')
      .gsub(/<tiles:put\s+name=\"([^\"]+)\"[^>]+>/, '<% content_for :\1 do # TODO: tiles:put multi %>')
      .gsub(/<tiles:insert[^>]+>/, '')
      .gsub(/<\/tiles:insert>/, '')
      .gsub(/<\/c:when>/, '')
      .gsub(/<\/c:otherwise>/, '')
      .gsub(/<\/tiles:put>/, '<% end %>')
      .gsub(/<\/c:forEach>/, '<% end %>')
      .gsub(/<\/c:if>/, '<% end %>')
      .gsub(/<\/c:choose>/, '<% end %>')
      .gsub(/<c:choose>[\n\s]+<c:when\s+test=\"\${([^}]+)}\">/, '<% if \1 # TODO: c:choose %>')
      .gsub(/<c:when\s+test=\"\${([^}]+)}\">/, '<% elsif \1 # TODO: c:when %>')
      .gsub(/<c:otherwise>/, '<% else # TODO: c:otherwise %>')
      .gsub(/<c:if\s+test="\${([^}]+)}">/, '<% if \1 # TODO: c:if %>')
      .gsub(/<c:forEach\s+var=\"([^\"]+)\"\s+items=\"\${([^}]+)}\">/, '<% \2.each do |\1| # TODO: c:forEach %>')
      .gsub(/<c:import\s+url="([^"]+)"\/>/, '<%= render partial: "\1" # TODO: c:import %>')
      .gsub(/\${([^}]+)}/, '<%= \1 # TODO: interpolation %>')
  end
end
