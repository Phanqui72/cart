package data;

import business.Product;
import java.util.ArrayList;
import java.util.List;

public class ProductIO {

    private static final List<Product> products = new ArrayList<>();

    static {
        // Populate the list of products
        Product p1 = new Product();
        p1.setCode("8601");
        p1.setDescription("86 (the band) - True Life Songs and Pictures");
        p1.setPrice(14.95);
        products.add(p1);

        Product p2 = new Product();
        p2.setCode("pf01");
        p2.setDescription("Paddlefoot - The first CD");
        p2.setPrice(12.95);
        products.add(p2);

        Product p3 = new Product();
        p3.setCode("pf02");
        p3.setDescription("Paddlefoot - The second CD");
        p3.setPrice(14.95);
        products.add(p3);

        Product p4 = new Product();
        p4.setCode("jr01");
        p4.setDescription("Joe Rut - Genuine Wood Grained Finish");
        p4.setPrice(14.95);
        products.add(p4);
    }

    public static List<Product> getProducts() {
        return products;
    }

    public static Product getProduct(String productCode) {
        for (Product p : products) {
            if (productCode != null && productCode.equals(p.getCode())) {
                return p;
            }
        }
        return null;
    }
}