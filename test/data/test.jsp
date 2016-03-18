<c:set var="eventLabel">category</c:set>
<%-- イベント --%>
<tiles:put name="title" value="qa" />
<% content_for :title do %>qa<% end %>
<tiles:put name="content" type="string">
</tiles:put>
<% content_for :meta do %>
  <meta name="robots" content="noindex,follow">
<% end %>

# 書き換え
${event}
<c:forEach var="category" items="${categories}">
</c:forEach>
<c:choose>
  <c:when test="${sort == 'hoge'}">
  </c:when>
  <c:when test="${sort == 'fuga'}">
  </c:when>
  <c:otherwise>
  </c:otherwise>
</c:choose>
<c:if test="${!empty q}">
</c:if>
<c:import url="/WEB-INF/view/adition.jsp"/>
<%= render partial: '/WEB-INF/view/adition.jsp' %>

# 削除
<tiles:insert template="/WEB-INF/view/common/renewal/baseLayout.jsp" flush="true">
</tiles:insert>
