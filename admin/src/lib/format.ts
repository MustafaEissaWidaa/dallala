// Dashboard formatting: Latin digits and the Africa/Khartoum timezone (spec §8).
export const TIMEZONE = "Africa/Khartoum";

const numberFmt = new Intl.NumberFormat("en-US");

export function formatNumber(value: number): string {
  return numberFmt.format(value);
}

/** Whole Sudanese pounds → "45,000 ج.س". */
export function formatPrice(amount: number): string {
  return `${formatNumber(amount)} ج.س`;
}

const dateTimeFmt = new Intl.DateTimeFormat("ar-SD-u-nu-latn", {
  timeZone: TIMEZONE,
  dateStyle: "medium",
  timeStyle: "short",
});

export function formatDateTime(value: Date | string): string {
  return dateTimeFmt.format(typeof value === "string" ? new Date(value) : value);
}
