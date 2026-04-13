package com.rusefi.ui;

/**
 * @see StatusWindow
 */
public interface StatusConsumer {
    StatusConsumer ANONYMOUS = (status) -> System.out.println(status);
    StatusConsumer VOID = (status) -> {};

    void logLine(String status);
}
