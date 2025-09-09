package business;

import java.io.Serializable;
import java.text.NumberFormat;

public class LineItem implements Serializable {
    private Product product;
    private int quantity;

    public LineItem() {}

    // Getters and Setters
    public void setProduct(Product p) { product = p; }
    public Product getProduct() { return product; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public int getQuantity() { return quantity; }

    public double getTotal() {
        return product.getPrice() * quantity;
    }

    public String getTotalCurrencyFormat() {
        NumberFormat currency = NumberFormat.getCurrencyInstance();
        return currency.format(this.getTotal());
    }
}