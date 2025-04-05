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
