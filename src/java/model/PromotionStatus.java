/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public enum PromotionStatus {
    active, expired;

	public static PromotionStatus fromString(String status) {
        if (status != null) {
            for (PromotionStatus ps : PromotionStatus.values()) {
                if (ps.name().equalsIgnoreCase(status)) {
                    return ps;
                }
            }
        }
        throw new IllegalArgumentException("Invalid status: " + status);
    }
}
