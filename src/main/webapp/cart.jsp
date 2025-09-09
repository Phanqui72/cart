<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> <%-- Sử dnjg jakarta --%>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <link rel="stylesheet" href="css/main.css">
</head>
<body>

    <h1>Your Cart</h1>
    <p class="error">${message}</p>

    <table class="cart-table">
        <tr>
            <th>Quantity</th>
            <th>Description</th>
            <th class="right">Price</th>
            <th class="right">Amount</th>
            <th></th>
        </tr>

        <c:forEach var="item" items="${cart.items}">
            <tr>
                <td>
                    <form action="cart" method="post">
                        <input type="hidden" name="productCode" value="${item.product.code}">
                        <input type="text" name="quantity" value="${item.quantity}" size="3">
                        <input type="submit" value="Update">
                    </form>
                </td>
                <td>${item.product.description}</td>
                <td class="right">$${item.product.price}</td>
                <td class="right">$${item.total}</td>
                <td>
                    <form action="cart" method="post">
                        <input type="hidden" name="productCode" value="${item.product.code}">
                        <input type="hidden" name="quantity" value="0">
                        <input type="submit" value="Remove Item">
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>

    <p>To change the quantity, enter the new quantity and click on the Update button.</p>

    <div class="cart-buttons">
        <form action="${pageContext.request.contextPath}/index.jsp" method="get">
            <input type="submit" value="Continue Shopping">
        </form>
        <form action="#" method="post">
            <input type="submit" value="Checkout">
        </form>
    </div>

</body>
</html>