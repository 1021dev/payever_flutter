enum SortType {
  name,
  highTotal,
  lowTotal,
  date
}

enum FilterType {
  id,
  reference,
  date,
  payment_type,
  status,
  specific_status,
  channel,
  amount,
  total,
  currency,
  customer_name,
  customer_email,
  merchant_name,
  merchant_email,
  seller_name,
  seller_email
}
/*
  CreatedAt = 'created_at',
  Status = 'status',
  SpecificStatus = 'specific_status',
  Channel = 'channel',
  Store = 'store',
  Amount= 'amount',
  Total = 'total',
  Currency = 'currency',
  CustomerName = 'customer_name',
  CustomerEmail = 'customer_email',
  MerchantName = 'merchant_name',
  MerchantEmail = 'merchant_email',
  SellerName = 'seller_name',
  SellerEmail = 'seller_email',
  Type = 'type',
  OriginalId = 'original_id',
  Reference = 'reference',

 */
enum FilterCondition {
  con_is,
  con_isIn,
  con_isNot,
  con_isNotIn,
  con_isDate,
  con_isNotDate,
  con_startsWith,
  con_endsWith,
  con_contains,
  con_doesNotContain,
// DynamicTypes:
  con_greaterThan,
  con_lessThan,
  con_between,
  con_afterDate,
  con_beforeDate,
  con_betweenDates,
}

String getFilterNameByType(FilterType type) {
  String typeString = "Id";
  switch (type) {
    case FilterType.id:
      {
        typeString = "Id";
      }
      break;
    case FilterType.reference:
      {
        typeString = "Reference";
      }
      break;
    case FilterType.date:
      {
        typeString = "Date";
      }
      break;
    case FilterType.payment_type:
      {
        typeString = "Payment Type";
      }
      break;
    case FilterType.status:
      {
        typeString = "Status";
      }
      break;
    case FilterType.specific_status:
      {
        typeString = "Specific Status";
      }
      break;
    case FilterType.channel:
      {
        typeString = "Channel";
      }
      break;
    case FilterType.amount:
      {
        typeString = "Amount";
      }
      break;
    case FilterType.total:
      {
        typeString = "Total";
      }
      break;
    case FilterType.currency:
      {
        typeString = "Currency";
      }
      break;
    case FilterType.customer_name:
      {
        typeString = "Customer name";
      }
      break;
    case FilterType.customer_email:
      {
        typeString = "Customer email";
      }
      break;
    case FilterType.merchant_name:
      {
        typeString = "Merchant name";
      }
      break;
    case FilterType.merchant_email:
      {
        typeString = "Merchant email";
      }
      break;
    case FilterType.seller_name:
      {
        typeString = "Seller name";
      }
      break;
    case FilterType.seller_email:
      {
        typeString = "Seller email";
      }
      break;
    default:
      {
        typeString = "Id";
      }
      break;
  }
  return typeString;
}

String getFilterConditionNameByCondition(FilterCondition condition) {
  switch(condition) {
    case FilterCondition.con_is:
      return 'is';
    case FilterCondition.con_isIn:
      return 'isIn';
    case FilterCondition.con_isNot:
      return 'isNot';
    case FilterCondition.con_isNotIn:
      return 'isNotIn';
    case FilterCondition.con_isDate:
      return 'isDate';
    case FilterCondition.con_isNotDate:
      return 'isNotDate';
    case FilterCondition.con_startsWith:
      return 'startsWith';
    case FilterCondition.con_endsWith:
      return 'endsWith';
    case FilterCondition.con_contains:
      return 'contains';
    case FilterCondition.con_doesNotContain:
      return 'doesNotContain';
    case FilterCondition.con_greaterThan:
      return 'greaterThan';
    case FilterCondition.con_lessThan:
      return 'lessThan';
    case FilterCondition.con_between:
      return 'between';
    case FilterCondition.con_afterDate:
      return 'afterDate';
    case FilterCondition.con_beforeDate:
      return 'beforeDate';
    case FilterCondition.con_betweenDates:
      return 'betweenDates';
    default:
      return '';

  }
}
/*
Is = 'is',
IsIn = 'isIn',
IsNot = 'isNot',
IsNotIn = 'isNotIn',
IsDate = 'isDate',
IsNotDate = 'isNotDate',
StartsWith = 'startsWith',
EndsWith = 'endsWith',
Contains = 'contains',
DoesNotContain = 'doesNotContain',
// DynamicTypes:
GreaterThan = 'greaterThan',
LessThan = 'lessThan',
Between = 'between',
AfterDate = 'afterDate',
BeforeDate = 'beforeDate',
BetweenDates = 'betweenDates'
*/

String hintTextByFilter(FilterType type) {
  switch (type) {
    case FilterType.id:
      return 'Search';
    case FilterType.reference:
      return 'Search';
    case FilterType.date:
      return 'Date';
    case FilterType.payment_type:
      return 'Option';
    case FilterType.status:
      return 'Option';
    case FilterType.specific_status:
      return 'Option';
    case FilterType.channel:
      return 'Option';
    case FilterType.amount:
      return 'Search';
    case FilterType.total:
      return 'Search';
    case FilterType.currency:
      return 'Option';
    case FilterType.customer_name:
      return 'Search';
    case FilterType.customer_email:
      return 'Search';
    case FilterType.merchant_name:
      return 'Search';
    case FilterType.merchant_email:
      return 'Search';
    case FilterType.seller_name:
      return 'Search';
    case FilterType.seller_email:
      return 'Search';
    default:
      return 'Search';
  }
}

List<FilterCondition> filterConditionsByFilterType(FilterType type) {
  switch (type) {
    case FilterType.id:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
        FilterCondition.con_startsWith,
        FilterCondition.con_endsWith,
        FilterCondition.con_contains,
        FilterCondition.con_doesNotContain,
      ];
    case FilterType.reference:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
        FilterCondition.con_startsWith,
        FilterCondition.con_endsWith,
        FilterCondition.con_contains,
        FilterCondition.con_doesNotContain,
      ];
    case FilterType.date:
      return [
        FilterCondition.con_isDate,
        FilterCondition.con_isNotDate,
        FilterCondition.con_afterDate,
        FilterCondition.con_beforeDate,
        FilterCondition.con_beforeDate,
        FilterCondition.con_doesNotContain,
      ];
    case FilterType.payment_type:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
      ];
    case FilterType.status:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
      ];
    case FilterType.specific_status:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
      ];
    case FilterType.channel:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
      ];
    case FilterType.amount:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
        FilterCondition.con_greaterThan,
        FilterCondition.con_lessThan,
        FilterCondition.con_between,
      ];
    case FilterType.total:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
        FilterCondition.con_greaterThan,
        FilterCondition.con_lessThan,
        FilterCondition.con_between,
      ];
    case FilterType.currency:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
      ];
    case FilterType.customer_name:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
        FilterCondition.con_startsWith,
        FilterCondition.con_endsWith,
        FilterCondition.con_contains,
        FilterCondition.con_doesNotContain,
      ];
    case FilterType.customer_email:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
        FilterCondition.con_startsWith,
        FilterCondition.con_endsWith,
        FilterCondition.con_contains,
        FilterCondition.con_doesNotContain,
      ];
    case FilterType.merchant_name:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
        FilterCondition.con_startsWith,
        FilterCondition.con_endsWith,
        FilterCondition.con_contains,
        FilterCondition.con_doesNotContain,
      ];
    case FilterType.merchant_email:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
        FilterCondition.con_startsWith,
        FilterCondition.con_endsWith,
        FilterCondition.con_contains,
        FilterCondition.con_doesNotContain,
      ];
    case FilterType.seller_name:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
        FilterCondition.con_startsWith,
        FilterCondition.con_endsWith,
        FilterCondition.con_contains,
        FilterCondition.con_doesNotContain,
      ];
    case FilterType.seller_email:
      return [
        FilterCondition.con_is,
        FilterCondition.con_isNot,
        FilterCondition.con_startsWith,
        FilterCondition.con_endsWith,
        FilterCondition.con_contains,
        FilterCondition.con_doesNotContain,
      ];
    default:
      return [];
  }
}