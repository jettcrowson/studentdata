students = []
eyeColors = []
ages = []
heights = []
bloodtypes = []

File.open("./student_data.csv").each do |line|
    info = line.split(",")
    students.push(info[0].strip)
    eyeColors.push(info[1].strip)
    ages.push(info[2].strip.to_i)
    heights.push([info[3].strip.to_i, info[4].strip.to_i])
    bloodtypes.push(info[5].strip)
end

def eyeColorStudents(color, eyeColorArray, studentArray, ageArray)
    #returns number, all students with eye color, and indexes of those students
    studentColors = []
    studentIndexes = []
    studentAges = []

    eyeColorArray.each_with_index do |eyeColor, i|
        if eyeColor.downcase == color.downcase
            studentColors.push(studentArray[i])
            studentIndexes.push(i)
        end    
    end

    studentIndexes.each do |i|
        studentAges.push(ageArray[i])
    end

    return [studentColors.length, studentColors, studentIndexes, studentAges]
end

def oldEnoughToDrive(ageArray,studentArray)
    oldEnough = []

    ageArray.each_with_index do |age, i|
        if age >= 16
            oldEnough.push(studentArray[i])
        end
    end

    return oldEnough
end

def vowelCounter(word)
    vowels = 0
    vowelList = ["a", "e", "i", "o", "u"]

    word.split("").each do |letter|
        if vowelList.include?(letter.downcase)
            vowels += 1
        end
    end

    return vowels
end

def studentsOfAge(age, ageArray, studentArray)
    studentsMatchingAge = []
    ageArray.each_with_index do |age,i|
        if age == 15
            studentsMatchingAge.push(studentArray[i])
        end
    end
    return studentsMatchingAge
end

def mostVowelsSophomores(ageArray, sudentsArray)
    longest = ""
    studentsOfAge(15, ageArray, sudentsArray).each do |name|
        if vowelCounter(name) > vowelCounter(longest)
            longest = name
        end
    end

    return longest
end

def toInches(heightArray)
    return (heightArray[0] * 12) + heightArray[1]
end

def averageHeight(heightArray)
    total = 0.0
    numberStudents = 0

    heightArray.each do |heightArray|
        total += toInches(heightArray)
        numberStudents += 1
    end

    return total / numberStudents
end

def averageAge(ageArr)
    total = 0.0
    numberStudents = 0

    ageArr.each do |ageArray|
        total += ageArray
        numberStudents += 1
    end

    return total / numberStudents
end

def findAges(studentIndexes, ageArray)
    ageList = []

    studentIndexes.each do |i|
        ageList.push(ageArray[i])
    end

    return ageList
end

def getNames(students, indexes)
    studentList = []
    
    indexes.each do |i|
        studentList.push(students[i])
    end

    return studentList
end

def closestToAgeByEyeColor(color, eyeColors, students, ages)
    closestStudents = []
    average = averageAge(findAges(eyeColorStudents(color, eyeColors, students, ages)[2], ages))
    studentsI = eyeColorStudents(color, eyeColors, students, ages)[2]
    studentsNames = getNames(students, studentsI)
    closest = [0]


    studentsI.each do |i|
        if (average - ages[i]).abs < (average - ages[closest[0]]).abs
            closest = []
            closest.push(i)
        elsif (average - ages[i]).abs == (average - ages[closest[0]]).abs
            closest.push(i)
        end
    end
    
    return getNames(students, closest)
end

def donatableBloodTypes(bloodtype)
    case bloodtype
    when "A"
        return ["O", "A"]
    when "B"
            return ["O", "B"]
    when "O"
        return ["O"]
    else
        return ["AB", "O", "B", "A"]
    end
end

def nameToBloodtype(name, bloodList, students)
    students.each_with_index do |student, i|
        if student == name
            return bloodList[i]
        end
    end

    return "O"
end

def bloodStudents(students, bloodList, desiredBloodtype)
    donors = []
    donatableBloodTypes(desiredBloodtype).each do |types|
        students.each do |name|
            if types == nameToBloodtype(name, bloodList, students)
                donors.push(name)
            else
            end
        end
    end

    return donors
end

def mostDonors(students, bloodtypes)
    mostDonors = []
    donorNumber = 0

    students.each do |name|
        if bloodStudents(students, bloodtypes, nameToBloodtype(name, bloodtypes, students)).length > donorNumber

            mostDonors = [name]
            donorNumber = bloodStudents(students, bloodtypes, nameToBloodtype(name, bloodtypes, students)).length

        elsif bloodStudents(students, bloodtypes, nameToBloodtype(name, bloodtypes, students)).length == donorNumber

            mostDonors.push(name)

        end
    end

    return [mostDonors, donorNumber]
end

puts "-----"

puts "How many students have brown eyes?"
puts eyeColorStudents("brown", eyeColors, students, ages)[0]

puts "-----"

puts "List of students old enough to drive"
puts oldEnoughToDrive(ages, students)

puts "-----"

puts "List of green eyed girls"
puts eyeColorStudents("green", eyeColors, students, ages)[1]

puts "-----"

puts "Which 15 year old has the most vowels in their name?"
puts mostVowelsSophomores(ages, students)

puts "-----"

puts "What is the average height of the students?"
puts averageHeight(heights)

puts "-----"

puts "What is the average age of green eyed students?"
puts averageAge(findAges(eyeColorStudents("green", eyeColors, students, ages)[2], ages))

puts "-----"

puts "Which green eyed students are closest to the average?"
puts closestToAgeByEyeColor("green", eyeColors, students, ages)

puts "-----"

puts "What bloodtype can the student recieve dontations from?"
puts donatableBloodTypes(nameToBloodtype("Alice", bloodtypes, students))

puts "-----"

puts "Which students can donate to our student?"
puts bloodStudents(students, bloodtypes, nameToBloodtype("Alice", bloodtypes, students))

puts "-----"

puts "The students with the most donors were"
puts mostDonors(students, bloodtypes)[0]
puts "With this many donors each"
puts mostDonors(students, bloodtypes)[1]
