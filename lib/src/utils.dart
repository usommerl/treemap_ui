library treemapUtils;

/**
 *  Calculates [amount] as percentage of [basicValue].
 */
num percentage(num amount, num basicValue) {
  assert(basicValue >= amount && amount >= 0);
  return (amount / basicValue) * 100;
}

/**
 *  Calculates the percentage value from [basicValue] and [percentage].
 */
num percentageValue(num basicValue, num percentage) {
  assert(percentage >= 0 && percentage <= 100);
  return (basicValue / 100) * percentage;
}