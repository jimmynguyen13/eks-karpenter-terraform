import http from "k6/http";
import { sleep, check } from "k6";

// === Config ===
export let options = {
  stages: [
    { duration: "30s", target: 20 },
    { duration: "1m", target: 50 },
    { duration: "2m", target: 100 },
    { duration: "1m", target: 0 }
  ],
  thresholds: {
    http_req_duration: ["p(95)<500"], // 95% request < 500ms
    http_req_failed: ["rate<0.05"] // <5% lỗi
  }
};

export default function () {
  const url = __ENV.API_URL || "https://eks-karpenter-demo.com/time";
  const res = http.get(url);
  check(res, {
    "status is 200": (r) => r.status === 200,
    "body has ISO date": (r) => /\d{4}-\d{2}-\d{2}T/.test(r.body)
  });
  sleep(1);
}
