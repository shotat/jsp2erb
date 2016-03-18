require 'test_helper'

class Jsp2erbTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jsp2erb::VERSION
  end

  def test_c_set_tag
    assert { Jsp2erb.convert('<c:set var="eventLabel">category</c:set>') == '<% eventLabel = "category" # TODO: c:set %>' }
  end
  def test_comment_tag
    assert { Jsp2erb.convert('<%-- イベント --%>') == '<%# イベント %>' }
  end
  def test_tiles_put_single
    assert { Jsp2erb.convert('<tiles:put name="title" value="qa" />') == '<% content_for :title do # TODO: tiles:put single %>qa<% end %>' }
  end
  def test_tiles_put_multi
    assert { Jsp2erb.convert('<tiles:put name="content" type="string">') == '<% content_for :content do # TODO: tiles:put multi %>' }
  end
  def test_end_tags
    assert { Jsp2erb.convert('</tiles:put>') == '<% end %>' }
    assert { Jsp2erb.convert('</c:forEach>') == '<% end %>' }
    assert { Jsp2erb.convert('</c:choose>') == '<% end %>' }
    assert { Jsp2erb.convert('</c:if>') == '<% end %>' }
    assert { Jsp2erb.convert('</tiles:insert>') == '' }
  end
  def test_interpolation
    assert { Jsp2erb.convert('${event}') == '<%= event # TODO: interpolation %>' }
  end
  def test_for_each
    assert { Jsp2erb.convert('<c:forEach var="category" items="${categories}">') == '<% categories.each do |category| # TODO: c:forEach %>' }
  end
  def test_c_when_and_c_otherwise
    assert { Jsp2erb.convert('</c:when>') == '' }
    assert { Jsp2erb.convert('</c:otherwise>') == '' }
  end
  def test_tiles_insert
    assert { Jsp2erb.convert('<tiles:insert template="/WEB-INF/view/common/renewal/baseLayout.jsp" flush="true">') == '' }
  end
  def test_c_choose_c_when
    assert { Jsp2erb.convert("<c:choose>\n <c:when test=\"${sort == 'hoge'}\">") == '<% if sort == \'hoge\' # TODO: c:choose %>' }
  end
  def test_c_when_after_second
    assert { Jsp2erb.convert('<c:when test="${sort == \'fuga\'}">') == '<% elsif sort == \'fuga\' # TODO: c:when %>' }
  end
  def test_c_otherwise
    assert { Jsp2erb.convert('<c:otherwise>') == '<% else # TODO: c:otherwise %>' }
  end
  def test_c_if
    assert { Jsp2erb.convert('<c:if test="${!empty q}">') == '<% if !empty q # TODO: c:if %>' }
  end
  def test_import
    assert { Jsp2erb.convert('<c:import url="/WEB-INF/view/adition.jsp"/>') == '<%= render partial: "/WEB-INF/view/adition.jsp" # TODO: c:import %>' }
  end
  def test_sample
    expect = <<SAMPLE
<% eventLabel = "category" # TODO: c:set %>
<%# イベント %>
<% content_for :title do # TODO: tiles:put single %>qa<% end %>
<% content_for :title do %>qa<% end %>
<% content_for :content do # TODO: tiles:put multi %>
<% end %>
<% content_for :meta do %>
  <meta name="robots" content="noindex,follow">
<% end %>

# 書き換え
<%= event # TODO: interpolation %>
<% categories.each do |category| # TODO: c:forEach %>
<% end %>
<% if sort == 'hoge' # TODO: c:choose %>
  
  <% elsif sort == 'fuga' # TODO: c:when %>
  
  <% else # TODO: c:otherwise %>
  
<% end %>
<% if !empty q # TODO: c:if %>
<% end %>
<%= render partial: "/WEB-INF/view/adition.jsp" # TODO: c:import %>
<%= render partial: '/WEB-INF/view/adition.jsp' %>

# 削除


SAMPLE
    assert { Jsp2erb.convert(File.read('test/data/test.jsp')) == expect }
  end
end
