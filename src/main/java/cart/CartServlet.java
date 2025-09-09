package cart;

import business.Cart;
import business.LineItem;
import business.Product;
import data.ProductIO; // Sửa tên class này nếu bạn đặt tên khác

import jakarta.servlet.ServletContext; // <-- THÊM DÒNG NÀY
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;


//Bất kỳ yêu cầu nào từ trình duyệt gửi đến URL /cart thì hãy giao cho Servlet này xử lý
//loadOnStartup = 1: Đây là một chỉ thị rất quan trọng. Nó yêu cầu Tomcat phải khởi tạo
// Servlet này ngay khi ứng dụng bắt đầu chạy, chứ không đợi người dùng truy cập lần đầu.
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"}, loadOnStartup = 1)
public class CartServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        // Tải danh sách sản phẩm một lần khi servlet khởi động
        // và lưu nó vào application scope (ServletContext)
        List<Product> products = ProductIO.getProducts();
        getServletContext().setAttribute("products", products);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String url = "/index.jsp";
        ServletContext sc = getServletContext();

        // Lấy hành động hiện tại
        String action = request.getParameter("action");
        if (action == null) {
            action = "cart"; // Hành động mặc định là hiển thị giỏ hàng
        }

        // Chuyển hướng nếu người dùng muốn tiếp tục mua sắm
        if (action.equals("shop")) {
            url = "/index.jsp";
        } else if (action.equals("cart")) {
            String productCode = request.getParameter("productCode");
            String quantityString = request.getParameter("quantity");

            HttpSession session = request.getSession();
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
            }

            // Nếu người dùng thêm/cập nhật/xóa sản phẩm
            if (productCode != null && !productCode.isEmpty()) {
                Product product = ProductIO.getProduct(productCode);
                if (product != null) {
                    // Mặc định số lượng là 1 nếu không được cung cấp (khi nhấn "Add to Cart")
                    if (quantityString == null || quantityString.isEmpty()){
                        quantityString = "1";
                    }

                    try {
                        int quantity = Integer.parseInt(quantityString);
                        if (quantity < 0) {
                            quantity = 1;
                        }

                        LineItem lineItem = new LineItem();
                        lineItem.setProduct(product);
                        lineItem.setQuantity(quantity);

                        if (quantity > 0) {
                            cart.addItem(lineItem);
                        } else { // Số lượng là 0 thì xóa
                            cart.removeItem(lineItem);
                        }
                    } catch (NumberFormatException e) {
                        // Xử lý nếu quantity không phải là số
                        System.err.println("Invalid quantity format for productCode: " + productCode);
                    }
                }
            }
            session.setAttribute("cart", cart);
            url = "/cart.jsp";
        }

        // Chuyển tiếp yêu cầu đến trang JSP
        sc.getRequestDispatcher(url).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}