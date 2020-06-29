package org.payever.app.taponphone.listener;

public interface TransactionListener {

    /**
     * Invoked for offline apprroval
     */
    void onTransactionSuccessful();

    /**
     * Invoked when requires online approval
     */
    void onOnlineReferral();

    /**
     * Invoked when transaction is declined
     */
    void onTransactionDeclined();

    /**
     * Invoked when SDK ends due to error
     */
    void onApplicationEnded();

    /**
     * Invoked when transaction is cancelled
     */
    void onTransactionCancelled();
}
