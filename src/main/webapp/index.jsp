<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>  <%-- kích hoạt thư viện JSTL --%>
<%@ page isELIgnored="false" %>     <%-- kích hoạt thư viện EL (true thì bỏ qua, false thì xài) --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CD list</title>
    <link rel="stylesheet"  href="css/main.css">
</head>
<body>

<h1>CD list</h1>

<table>
    <tr>
        <th>Description</th>
        <th class="right">Price</th>
        <th></th>
    </tr>

    <c:forEach var="product" items="${products}">
        <tr>
            <td><c:out value="${product.description}" /></td>
            <td class="right">$<c:out value="${product.price}" /></td>
            <td>
                <form action="cart" method="post">
                    <input type="hidden" name="productCode" value="<c:out value='${product.code}'/>">
                    <input type="submit" value="Add To Cart">
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>