import { Sidebar } from "@/components/sidebar";
import { formatPrice } from "@/lib/format";

// Phase 1 shell. KPIs are wired to Supabase in Phase 8.
const KPIS = [
  { label: "إعلانات جديدة", value: "—" },
  { label: "مستخدمين جدد", value: "—" },
  { label: "بانتظار المراجعة", value: "—" },
  { label: "بلاغات مفتوحة", value: "—" },
  { label: "طلبات شحن معلّقة", value: "—" },
  { label: "إيراد الشحن اليوم", value: formatPrice(0) },
];

export default function OverviewPage() {
  return (
    <div className="flex min-h-screen bg-sand text-ink">
      <Sidebar active="/" />
      <main className="flex-1 p-8">
        <h1 className="font-display text-2xl font-bold">نظرة عامة</h1>
        <div className="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {KPIS.map((k) => (
            <div
              key={k.label}
              className="rounded-card border border-line bg-surface p-5 shadow-card"
            >
              <p className="text-sm text-ink-muted">{k.label}</p>
              <p className="mt-2 font-display text-3xl font-bold">{k.value}</p>
            </div>
          ))}
        </div>
      </main>
    </div>
  );
}
