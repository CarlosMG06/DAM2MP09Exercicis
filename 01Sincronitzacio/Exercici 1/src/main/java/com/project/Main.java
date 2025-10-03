package com.project;

import java.util.Arrays;
import java.util.concurrent.*;

public class Main {

    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(3);
        
        // Exemple de dades
        int[] dades = new int[10]; 
        for (int i = 0; i < dades.length; i++) {
            dades[i] = (int) (Math.random() * 100 + 1);
        }

        ConcurrentHashMap<String, Double> resultats = new ConcurrentHashMap<>();

        CyclicBarrier barrier = new CyclicBarrier(3, () -> {
            System.out.println("Totes les tasques han acabat.");
            System.out.println("Dades inicials: " + Arrays.toString(dades));
            System.out.println("Suma: " + resultats.get("suma"));
            System.out.println("Mitjana: " + resultats.get("mitjana"));
            System.out.println("Desviació estàndard: " + resultats.get("desviacio"));
        });

        Runnable sumaTask = () -> {
            try {
                System.out.println("Calculant la suma...");
                double suma = 0;
                for (double d : dades) {
                    suma += d;
                } 
                resultats.put("suma", suma);
                System.out.println("Suma calculada.");
                barrier.await(); 
            } catch (InterruptedException | BrokenBarrierException e) {
                Thread.currentThread().interrupt();
            }
        };

        Runnable mitjanaTask = () -> {
            try {
                System.out.println("Calculant la mitjana...");
                while (!resultats.containsKey("suma")) {
                    Thread.sleep(10);
                }
                double mitjana = resultats.get("suma") / dades.length;
                resultats.put("mitjana", mitjana);
                System.out.println("Mitjana calculada.");
                barrier.await();
            } catch (InterruptedException | BrokenBarrierException e) {
                Thread.currentThread().interrupt();
            }
        };

        Runnable desviacioTask = () -> {
            try {
                System.out.println("Calculant la desviacio estandard...");
                while (!resultats.containsKey("mitjana")) {
                    Thread.sleep(10);
                }
                double sumaQuadrats = 0;
                for (double d : dades) {
                    sumaQuadrats += Math.pow(d - resultats.get("mitjana"), 2);
                }
                double desviacio = Math.sqrt(sumaQuadrats / dades.length);
                resultats.put("desviacio", desviacio);
                System.out.println("Desviacio estandard calculada.");
                barrier.await(); 
            } catch (InterruptedException | BrokenBarrierException e) {
                Thread.currentThread().interrupt(); 
            }
        };

        executor.execute(sumaTask);
        executor.execute(mitjanaTask);
        executor.execute(desviacioTask);

        executor.shutdown();
    }
}