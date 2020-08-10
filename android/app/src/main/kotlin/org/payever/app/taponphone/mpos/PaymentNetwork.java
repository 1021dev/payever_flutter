package org.payever.app.taponphone.mpos;


import com.mastercard.terminalsdk.utility.ByteUtility;

import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

public enum PaymentNetwork {

    // For a adding a new entry, please refer
    // https://www.eftlab.co.uk/index.php/site-map/knowledge-base/212-emv-rid
    // OR any other reliable source of info

    MASTERCARD("A000000004"),

    MASTERCARD_QPBOC("A000000010"),

    VISA_INT_1("A000000003"),

    RUPAY("A000000524"),

    UNKNOWN("");

    String mRid;

    private static final Map<String, PaymentNetwork> REVERSE_LOOKUP = new HashMap();

    static {
        for (PaymentNetwork pymtNw : EnumSet.allOf(PaymentNetwork.class))
            REVERSE_LOOKUP.put(pymtNw.getRidString().toUpperCase(), pymtNw);
    }

    PaymentNetwork(String rid) {
        mRid = rid;
    }

    public byte[] getRidBytes() {
        return ByteUtility.hexStringToByteArray(mRid);
    }

    public String getRidString() {
        return mRid;
    }

    public static PaymentNetwork get(String rid) {
        PaymentNetwork identified = REVERSE_LOOKUP.get(rid.toUpperCase());
        return identified == null ? UNKNOWN : identified;
    }
}
