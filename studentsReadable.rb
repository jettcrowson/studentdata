require_relative "student"

students = []

File.open("./student_data.csv").each_with_index do |line, i|
    info = line.split(",")
    students[i] = Student.new(info[0].strip, info[1].strip, info[2].strip.to_i, [info[3].strip.to_i, info[4].strip.to_i], info[5].strip) 
end

def fetchAttribute(objList, attribute)
    attributeList = []

    objList.each do |obj|
        attributeList.push(obj.public_send(attribute))
    end

    return attributeList
end

def eyeColorStudents(color, students)
    studentsWithEyeColor = []    
        students.each_with_index do |student, i|
            if student.eyeColor.downcase == color.downcase
                studentsWithEyeColor.push(student)
            end    
        end
        return [studentsWithEyeColor.length, studentsWithEyeColor]
end

def oldEnoughToDrive(students)
    oldEnough = []
        students.each_with_index do |student, i|
            if student.age >= 16
                oldEnough.push(student.name)
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

def studentsOfAge(age, students)
        studentsMatchingAge = []
        students.each_with_index do |student,i|
            if student.age == age
                studentsMatchingAge.push(student)
            end
        end
    return studentsMatchingAge
end

def mostVowelsSophomores(students)
        longest = ""
        studentsOfAge(15, students).each do |student|
            if vowelCounter(student.name) > vowelCounter(longest)
                longest = student.name
            end
        end
    return longest
end

def toInches(heightArray)
    return (heightArray[0] * 12) + heightArray[1]
end

def average(list)
    total = 0.0
    list.each do |item|
        total += item
    end
    return total / list.length
end

def averageHeight(students)
    heights = []
    students.each{ |student| heights.push(toInches(student.height))} 
    return average(heights)
end

def averageAge(students)
    ages = []
    students.each{ |student| ages.push(student.age)} 
    return average(ages)
end
def closestToAgeByEyeColor(color, students)
        closestStudents = []
        average = averageAge(eyeColorStudents(color, students)[1])
        studentsList = eyeColorStudents(color, students)[1]
        ages = fetchAttribute(students, "age")
        closest = [studentsList[0]]
        studentsList.each do |student|
            if (average - student.age).abs < (average - closest[0].age).abs
                closest = []
                closest.push(student)
            elsif (average - student.age).abs == (average - closest[0].age).abs
                closest.push(student)
            end
        end
    return fetchAttribute(closest, "name")
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

def nameToBloodtype(name, students)
    students.each_with_index do |student, i|
        if student.name == name
            return student.bloodtype
        end
    end
    return "O"
end

def bloodStudents(students, desiredBloodtype)
        donors = []
        donatableBloodTypes(desiredBloodtype).each do |types|
            
            students.each do |student|
                if types == nameToBloodtype(student.name, students)
                    donors.push(student)
                end
            end
        end
    return donors
end

def mostDonors(students)
        mostDonors = []
        donorNumber = 0
        students.each do |student|
            if bloodStudents(students, nameToBloodtype(student.name, students)).length > donorNumber
                mostDonors = [student]
                donorNumber = bloodStudents(students, nameToBloodtype(student.name, students)).length
            elsif bloodStudents(students, nameToBloodtype(student.name, students)).length == donorNumber
                mostDonors.push(student)
            end
        end
    return [mostDonors, donorNumber]
end

def writeToFile(content, name)
        outFile = File.new("#{name}.txt", "w")
        outFile.puts(content)
        outFile.close
end

def secondLetterSort(students)
    orderedNames = [students[0].name]
    secondLetterNames = []
    putFirstBack = []

    students.each{ |student| secondLetterNames.push(student.name.split("").drop(1).push(student.name[0]).join(""))}

    secondLetterNames.sort.each{ |name| putFirstBack.push(name.split("").take(name.length-1).unshift(name[name.length-1]).join(""))}

    return putFirstBack
end

puts "-----"
puts "How many students have brown eyes?"
puts eyeColorStudents("brown", students)[0]
puts "-----"
puts "List of students old enough to drive"
puts oldEnoughToDrive(students)
puts "-----"
puts "List of green eyed students"
puts fetchAttribute(eyeColorStudents("green", students)[1], "name")
puts "-----"
puts "Which 15 year old has the most vowels in their name?"
puts mostVowelsSophomores(students)
puts "-----"
puts "What is the average height of the students?"
puts averageHeight(students)
puts "-----"
puts "What is the average age of green eyed students?"
puts averageAge(eyeColorStudents("green", students)[1])
puts "-----"
puts "Which green eyed students are closest to the average?"
puts closestToAgeByEyeColor("green", students)
puts "-----"
puts "What bloodtype can the student recieve dontations from?"
puts donatableBloodTypes(nameToBloodtype("Alice", students))
puts "-----"
puts "Which students can donate to our student?"
puts fetchAttribute(bloodStudents(students, nameToBloodtype("Alice", students)), "name")
puts "-----"
puts "The students with the most donors were"
puts fetchAttribute(mostDonors(students)[0], "name")
puts "With this many donors each"
puts mostDonors(students)[1]
puts "-----"
puts "Sort the students in alphebetical order according to the second letter of their names, ignoring the first."
puts secondLetterSort(students)

writeToFile(fetchAttribute(mostDonors(students)[0], "name"), "problem7")