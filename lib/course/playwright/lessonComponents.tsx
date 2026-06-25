import type { ComponentType } from "react";

import Lesson01 from "@/components/course/lessons/lesson-0-1";
import Lesson02 from "@/components/course/lessons/lesson-0-2";
import Lesson03 from "@/components/course/lessons/lesson-0-3";
import Lesson04 from "@/components/course/lessons/lesson-0-4";
import Lesson05 from "@/components/course/lessons/lesson-0-5";
import Lesson06 from "@/components/course/lessons/lesson-0-6";
import Lesson11 from "@/components/course/lessons/lesson-1-1";
import Lesson12 from "@/components/course/lessons/lesson-1-2";
import Lesson13 from "@/components/course/lessons/lesson-1-3";
import Lesson14 from "@/components/course/lessons/lesson-1-4";
import Lesson15 from "@/components/course/lessons/lesson-1-5";
import Lesson16 from "@/components/course/lessons/lesson-1-6";
import Lesson17 from "@/components/course/lessons/lesson-1-7";
import Lesson18 from "@/components/course/lessons/lesson-1-8";
import Lesson19 from "@/components/course/lessons/lesson-1-9";
import Lesson110 from "@/components/course/lessons/lesson-1-10";
import Lesson111 from "@/components/course/lessons/lesson-1-11";
import Lesson112 from "@/components/course/lessons/lesson-1-12";
import Lesson113 from "@/components/course/lessons/lesson-1-13";
import Lesson114 from "@/components/course/lessons/lesson-1-14";
import Lesson115 from "@/components/course/lessons/lesson-1-15";
import Lesson116 from "@/components/course/lessons/lesson-1-16";
import Lesson117 from "@/components/course/lessons/lesson-1-17";
import Lesson118 from "@/components/course/lessons/lesson-1-18";

export const LESSON_COMPONENTS: Record<string, ComponentType> = {
  "what-is-software-testing": Lesson01,
  "manual-vs-automated-testing": Lesson02,
  "what-a-website-is-made-of": Lesson03,
  "install-everything": Lesson04,
  "the-terminal-demystified": Lesson05,
  "your-roadmap": Lesson06,
  "what-is-javascript": Lesson11,
  "running-a-js-file": Lesson12,
  "let-and-const": Lesson13,
  "data-types": Lesson14,
  "template-literals": Lesson15,
  "comparison-operators": Lesson16,
  "logical-operators": Lesson17,
  "if-else-and-ternary": Lesson18,
  "for-loops": Lesson19,
  "function-declarations": Lesson110,
  "arrow-functions": Lesson111,
  "parameters-and-return": Lesson112,
  "why-the-web-is-asynchronous": Lesson113,
  "promises": Lesson114,
  "async-await": Lesson115,
  "try-catch": Lesson116,
  "object-destructuring": Lesson117,
  "mini-playwright-win": Lesson118,
};
