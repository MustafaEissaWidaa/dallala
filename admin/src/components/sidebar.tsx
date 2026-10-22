import Image from "next/image";
import Link from "next/link";

// Pages from spec §8 — routes are added in Phase 8.
const NAV = [
  { href: "/", label: "نظرة عامة" },
  { href: "/moderation", label: "المراجعة" },
  { href: "/listings", label: "كل الإعلانات" },
  { href: "/users", label: "المستخدمين" },
  { href: "/reports", label: "البلاغات" },
  { href: "/topups", label: "طلبات الشحن" },
  { href: "/transactions", label: "الإيرادات والحركات" },
  { href: "/packages", label: "باقات التمييز" },
  { href: "/payment-accounts", label: "حسابات الدفع" },
  { href: "/catalog", label: "الأقسام والمحليات" },
  { href: "/broadcast", label: "إشعار جماعي" },
  { href: "/activity", label: "سجل النشاط" },
  { href: "/settings", label: "الإعدادات" },
];

export function Sidebar({ active = "/" }: { active?: string }) {
  return (
    <aside className="sticky top-0 flex h-screen w-64 shrink-0 flex-col bg-header-ink text-on-header-ink">
      <div className="px-6 py-6">
        <Image
          src="/dallala-logo-reversed.svg"
          alt="دلّالة"
          width={132}
          height={48}
          priority
        />
      </div>
      <nav className="flex-1 overflow-y-auto px-3 pb-6">
        <ul className="space-y-1">
          {NAV.map((item) => {
            const isActive = item.href === active;
            return (
              <li key={item.href}>
                <Link
                  href={item.href}
                  aria-current={isActive ? "page" : undefined}
                  className={`block rounded-control px-3 py-2.5 text-sm font-medium transition-colors ${
                    isActive
                      ? "bg-terracotta text-on-terracotta"
                      : "text-on-header-ink/80 hover:bg-white/10"
                  }`}
                >
                  {item.label}
                </Link>
              </li>
            );
          })}
        </ul>
      </nav>
    </aside>
  );
}
