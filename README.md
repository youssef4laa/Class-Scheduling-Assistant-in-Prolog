# Class Scheduling Assistant in Prolog

*Originally developed as a project for the Concepts of Programming Languages course at the German University in Cairo (Spring Term 2025).*

A Prolog-based scheduling tool that generates conflict-free weekly timetables for university students, ensuring no overlapping courses and guaranteeing two days off each week.

## Features

- **Automatic Schedule Generation**: Computes a personalized timetable for each student based on their enrolled courses.
- **Conflict Detection**: Ensures no two courses occupy the same day–slot combination.
- **Day-Off Enforcement**: Guarantees each student has exactly two days off per week.
- **Course Lookup**: Finds which time slots a given course is taught.
- **Common Free Slots**: Identifies assembly hours when all students are simultaneously free within their study days.

## Predicates Implemented

1. **`university_schedule(-Schedules)`**  
   Returns a list of `sched(StudentID, Slots)` entries for all students.

2. **`student_schedule(+StudentID, -Slots)`**  
   Retrieves the slot list for a specific student.

3. **`no_clashes(+Slots)`**  
   Checks that no two slots overlap.

4. **`study_days(+Slots, +MaxDays)`**  
   Verifies the student’s schedule spans at most `MaxDays` distinct weekdays.

5. **`assembly_hours(+Schedules, -FreeSlots)`**  
   Computes the list of `slot(Day, SlotNumber)` when all students are free (excluding days off).

## Getting Started

### Prerequisites

- [SWI‑Prolog](https://www.swi-prolog.org/) (or any ISO‑compliant Prolog interpreter)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/<your‑username>/prolog-scheduler.git
   cd prolog-scheduler
   ```
2. Ensure `studentKB.pl` (the provided knowledge base) is in the same directory as `scheduler.pl`.

### Usage

1. Launch Prolog:
   ```bash
   swipl
   ```
2. Consult the knowledge base and your scheduler:
   ```prolog
   ?- consult('studentKB').
   ?- consult('scheduler').
   ```
3. Generate all schedules:
   ```prolog
   ?- university_schedule(S).
   ```
4. Query an individual student’s schedule:
   ```prolog
   ?- student_schedule(student_3, Slots).
   ```
5. Find common free assembly hours:
   ```prolog
   ?- university_schedule(All), assembly_hours(All, FreeSlots).
   ```

## Examples

```prolog
?- student_schedule(student_0, Slots).
Slots = [slot(saturday,2,csen202), slot(sunday,2,mech202), slot(monday,2,physics201)].

?- assembly_hours(S, AH).
AH = [slot(saturday,3), slot(saturday,4), slot(saturday,5)].
```

## Contributing

Feel free to submit issues and pull requests to improve functionality, add more predicates, or handle larger datasets.

## License

This project is released under the MIT License. See [LICENSE](LICENSE) for details.

